const API = (location.origin && location.origin.startsWith('http'))
  ? `${location.origin}/api/v2`
  : 'http://localhost:5469/api/v2';

const state = {
  email: '',
  category: 'generalKnowledge',
  question: null,
  mystery: false,
  locked: false,
  score: { totalScore: 0, totalAnswered: 0, correctCount: 0, wrongCount: 0 },
};

const $ = (id) => document.getElementById(id);

/* THEME */
const themeBtn = $('themeToggle');
const savedTheme = localStorage.getItem('quiz-theme') || 'dark';
document.documentElement.setAttribute('data-theme', savedTheme);
updateThemeLabel();
themeBtn.addEventListener('click', () => {
  const next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem('quiz-theme', next);
  updateThemeLabel();
});
function updateThemeLabel() {
  const t = document.documentElement.getAttribute('data-theme');
  themeBtn.querySelector('.label').textContent = t.toUpperCase();
}

/* CATEGORY CHIPS */
document.querySelectorAll('#categoryChips .chip').forEach((chip) => {
  chip.addEventListener('click', () => {
    document.querySelectorAll('#categoryChips .chip').forEach((c) => c.classList.remove('active'));
    chip.classList.add('active');
    state.category = chip.dataset.cat;
  });
});

/* MYSTERY TOGGLE */
$('mysteryToggle').addEventListener('change', (e) => {
  state.mystery = e.target.checked;
});

/* START */
$('startBtn').addEventListener('click', async () => {
  const email = $('userEmail').value.trim();
  if (!email) { flash('Informe um e-mail para começar.', 'err'); return; }
  state.email = email;
  state.score = { totalScore: 0, totalAnswered: 0, correctCount: 0, wrongCount: 0 };
  renderScore();
  $('setupCard').classList.add('hidden');
  $('resultCard').classList.add('hidden');
  $('quizCard').classList.remove('hidden');
  $('categoryTag').textContent = `// ${categoryLabel(state.category).toUpperCase()}`;
  await loadQuestion();
});

/* NEXT / FINISH / RESTART */
$('nextBtn').addEventListener('click', async () => {
  $('nextBtn').classList.add('hidden');
  $('feedback').classList.add('hidden');
  await loadQuestion();
});
$('finishBtn').addEventListener('click', finishQuiz);
$('restartBtn').addEventListener('click', () => {
  $('resultCard').classList.add('hidden');
  $('setupCard').classList.remove('hidden');
});

async function loadQuestion() {
  state.locked = false;
  try {
    const url = `${API}/questions/generate`
      + `?category=${encodeURIComponent(state.category)}`
      + `&userEmail=${encodeURIComponent(state.email)}`;
    const res = await fetch(url);
    const data = await res.json();
    if (res.status === 404 && /sem mais perguntas/i.test(data.message || '')) {
      onCategoryExhausted(data.message);
      return;
    }
    if (!res.ok) throw new Error(data.message || 'Erro ao buscar pergunta');
    state.question = data;
    $('qText').textContent = data.question;
    $('qPoints').textContent = data.points;
    renderOptions(data.options);
    setStatus(true);
  } catch (e) {
    setStatus(false);
    flash(e.message || 'Falha de rede.', 'err');
  }
}

function onCategoryExhausted(msg) {
  $('qText').textContent = msg || 'Sem mais perguntas nesta categoria.';
  $('qPoints').textContent = '✓';
  $('optionsGrid').innerHTML = '';
  $('nextBtn').classList.add('hidden');
  flash('Categoria concluída. Clique em FINALIZAR para ver o resultado.', 'ok');
}

function renderOptions(options) {
  const grid = $('optionsGrid');
  grid.innerHTML = '';
  const letters = ['A', 'B', 'C', 'D'];
  options.forEach((opt, i) => {
    const btn = document.createElement('button');
    btn.className = 'option-btn';
    btn.type = 'button';
    btn.innerHTML = `<span class="key">${letters[i] || (i + 1)}</span><span>${escapeHtml(opt)}</span>`;
    btn.addEventListener('click', () => submitAnswer(opt, btn));
    grid.appendChild(btn);
  });
}

async function submitAnswer(answer, btn) {
  if (state.locked || !state.question) return;
  state.locked = true;
  const allBtns = document.querySelectorAll('.option-btn');
  allBtns.forEach((b) => (b.disabled = true));
  btn.classList.add('selected');

  try {
    const res = await fetch(`${API}/questions/answer`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id: state.question.id,
        category: state.question.category,
        userEmail: state.email,
        answerResp: answer,
        revealResult: !state.mystery,
      }),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.message || 'Erro ao enviar resposta');

    state.score = {
      totalScore: data.totalScore ?? state.score.totalScore,
      totalAnswered: data.totalAnswered ?? state.score.totalAnswered,
      correctCount: data.correctCount ?? state.score.correctCount,
      wrongCount: data.wrongCount ?? state.score.wrongCount,
    };
    renderScore();

    // Mystery mode: API doesn't return correct/pointsEarned
    if (state.mystery || typeof data.correct === 'undefined') {
      btn.classList.remove('selected');
      btn.classList.add('mystery');
      flash('?? Resposta registrada. Continue jogando — o veredito vem no final.', 'ok');
    } else if (data.correct) {
      btn.classList.remove('selected');
      btn.classList.add('correct');
      flash(`✓ ACERTOU · +${data.pointsEarned} pts`, 'ok');
    } else {
      btn.classList.remove('selected');
      btn.classList.add('wrong');
      flash(`✗ ERROU · +${data.pointsEarned} pts`, 'err');
    }

    $('nextBtn').classList.remove('hidden');
  } catch (e) {
    flash(e.message, 'err');
    allBtns.forEach((b) => (b.disabled = false));
    state.locked = false;
  }
}

async function finishQuiz() {
  if (!state.email) {
    $('quizCard').classList.add('hidden');
    $('setupCard').classList.remove('hidden');
    return;
  }
  try {
    const res = await fetch(`${API}/quiz/result?userEmail=${encodeURIComponent(state.email)}`);
    const data = await res.json();
    $('rScore').textContent = data.totalScore ?? 0;
    $('rCorrect').textContent = data.correctCount ?? 0;
    $('rWrong').textContent = data.wrongCount ?? 0;
    $('rTotal').textContent = data.totalAnswered ?? 0;
  } catch (_) {
    $('rScore').textContent = state.score.totalScore;
    $('rCorrect').textContent = state.score.correctCount;
    $('rWrong').textContent = state.score.wrongCount;
    $('rTotal').textContent = state.score.totalAnswered;
  }
  $('quizCard').classList.add('hidden');
  $('resultCard').classList.remove('hidden');
}

function renderScore() {
  $('mScore').textContent = state.mystery ? '?' : state.score.totalScore;
  $('mCorrect').textContent = state.mystery ? '?' : state.score.correctCount;
  $('mWrong').textContent = state.mystery ? '?' : state.score.wrongCount;
  $('mTotal').textContent = state.score.totalAnswered;
}

function flash(msg, kind) {
  const el = $('feedback');
  el.textContent = msg;
  el.className = `feedback ${kind}`;
  el.classList.remove('hidden');
}

function setStatus(online) {
  const s = $('statusDot');
  s.textContent = online ? '● online' : '● offline';
  s.classList.toggle('offline', !online);
}

function categoryLabel(cat) {
  return {
    generalKnowledge: 'Conhecimento Geral',
    geography: 'Geografia',
    historyFashion: 'História & Moda',
    popCultureMusic: 'Pop & Música',
  }[cat] || cat;
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  })[c]);
}
