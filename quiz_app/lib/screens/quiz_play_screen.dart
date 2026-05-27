import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question.dart';
import '../models/answer_result.dart';
import '../models/quiz_result.dart';
import '../services/quiz_api_client.dart';
import 'result_screen.dart';

/// Tela principal de execução do quiz contendo o fluxo de perguntas e respostas.
///
/// Gerencia os estados de carregamento, escolha de opções, verificação de acerto/erro,
/// exibição do placar e submissão final da pontuação.
class QuizPlayScreen extends StatefulWidget {
  final QuizApiClient apiClient;
  final String email;
  final String category;
  final String categoryLabel;
  final bool mysteryMode;

  const QuizPlayScreen({
    super.key,
    required this.apiClient,
    required this.email,
    required this.category,
    required this.categoryLabel,
    required this.mysteryMode,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  Question? _question;
  bool _isLoading = false;
  bool _isLocked = false;
  String? _selectedOption;
  AnswerResult? _lastAnswerResult;
  String? _errorMsg;
  bool _isExhausted = false;
  String? _exhaustedMsg;

  // Score stats tracked locally & synchronized with API response (for normal mode)
  int _totalScore = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  int _totalAnswered = 0;

  @override
  void initState() {
    super.initState();
    _loadNextQuestion();
  }

  /// Carrega uma nova pergunta aleatória da categoria atual.
  ///
  /// Lida com a exaustão de perguntas e limites de sessão retornados pelo servidor.
  Future<void> _loadNextQuestion() async {
    setState(() {
      _isLoading = true;
      _isLocked = false;
      _selectedOption = null;
      _lastAnswerResult = null;
      _errorMsg = null;
    });

    try {
      final q = await widget.apiClient.generateQuestion(
        category: widget.category,
        userEmail: widget.email,
      );
      setState(() {
        _question = q;
        _isLoading = false;
      });
    } on CategoryExhaustedException catch (e) {
      setState(() {
        _isExhausted = true;
        _exhaustedMsg = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Envia a resposta selecionada pelo usuário para validação no servidor.
  ///
  /// Atualiza o painel de pontuação e ativa o feedback visual correspondente
  /// ao resultado obtido (ou oculta detalhes se estiver em Modo Mistério).
  Future<void> _submitAnswer(String option) async {
    if (_isLocked || _question == null) return;

    setState(() {
      _isLocked = true;
      _selectedOption = option;
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final result = await widget.apiClient.answerQuestion(
        id: _question!.id,
        category: _question!.category,
        userEmail: widget.email,
        answerResp: option,
        revealResult: !widget.mysteryMode,
      );

      setState(() {
        _lastAnswerResult = result;
        _totalAnswered = result.totalAnswered;
        
        if (!widget.mysteryMode) {
          _totalScore = result.totalScore ?? _totalScore;
          _correctCount = result.correctCount ?? _correctCount;
          _wrongCount = result.wrongCount ?? _wrongCount;
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLocked = false; // let them try again on error
        _selectedOption = null;
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Conclui o quiz, busca as estatísticas finais acumuladas no servidor e
  /// navega para a tela de resultados ([ResultScreen]).
  void _finishQuiz() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final finalResult = await widget.apiClient.getFinalResult(userEmail: widget.email);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: finalResult,
          ),
        ),
      );
    } catch (e) {
      // Fallback to local variables if final request fails
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar resultado final: $e. Mostrando local.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      
      // Navigate using whatever info we have
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: QuizResult(
              userEmail: widget.email,
              totalScore: _totalScore,
              totalAnswered: _totalAnswered,
              correctCount: _correctCount,
              wrongCount: _wrongCount,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060D),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00F0FF).withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF2BD6).withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top header bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUIZ::NEON',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF101426),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF78A0FF).withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF00FF9C),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ONLINE',
                              style: GoogleFonts.orbitron(
                                color: const Color(0xFF8A93B8),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        
                        // Score Strip Card
                        _buildScoreboard(),

                        const SizedBox(height: 24),

                        if (_isExhausted)
                          _buildExhaustedState()
                        else if (_errorMsg != null)
                          _buildErrorState()
                        else if (_question == null && _isLoading)
                          const SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(color: Color(0xFF00F0FF)),
                            ),
                          )
                        else if (_question != null)
                          _buildQuizState(),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreboard() {
    final showMystery = widget.mysteryMode;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF101426).withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF78A0FF).withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '// CATEGORIA: ${widget.categoryLabel.toUpperCase()}',
              style: GoogleFonts.orbitron(
                color: const Color(0xFF00F0FF),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildMetricCell('SCORE', showMystery ? '?' : '$_totalScore', const Color(0xFF00F0FF)),
                const SizedBox(width: 8),
                _buildMetricCell('OK', showMystery ? '?' : '$_correctCount', const Color(0xFF00FF9C)),
                const SizedBox(width: 8),
                _buildMetricCell('X', showMystery ? '?' : '$_wrongCount', const Color(0xFFFF3D6E)),
                const SizedBox(width: 8),
                _buildMetricCell('TOTAL', '$_totalAnswered', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCell(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF161C34).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF78A0FF).withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.orbitron(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.rajdhani(
                color: const Color(0xFF8A93B8),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizState() {
    final letters = ['A', 'B', 'C', 'D'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Question Panel with Points Badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161C34).withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF78A0FF).withValues(alpha: 0.12),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left vertical cyan accent line
                      Container(
                        width: 4,
                        color: const Color(0xFF00F0FF),
                      ),
                      // Question text content container
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                            bottom: 20,
                            left: 16,
                            right: 16,
                          ),
                          child: Text(
                            _question!.question,
                            style: GoogleFonts.rajdhani(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF2BD6), Color(0xFF7A5CFF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF2BD6).withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  '+${_question!.points} pts',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Options Grid (Custom vertical/grid based on size)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _question!.options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final opt = _question!.options[index];
            return _buildOptionButton(letters[index], opt);
          },
        ),

        const SizedBox(height: 24),

        // Feedback Banner
        if (_isLocked && _lastAnswerResult != null) _buildFeedbackBanner(),

        const SizedBox(height: 16),

        // Action Buttons Row
        Row(
          children: [
            // Next Button (Only visible after answered)
            if (_isLocked)
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loadNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: const Color(0xFF00F0FF).withValues(alpha: 0.4),
                    elevation: 6,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00F0FF), Color(0xFF7A5CFF)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'PRÓXIMA',
                            style: GoogleFonts.orbitron(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.black, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            if (_isLocked) const SizedBox(width: 12),

            // Finish button
            ElevatedButton(
              onPressed: _isLoading ? null : _finishQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: BorderSide(color: const Color(0xFF78A0FF).withValues(alpha: 0.22)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                height: 20,
                child: Center(
                  child: Text(
                    'FINALIZAR',
                    style: GoogleFonts.orbitron(
                      color: const Color(0xFF8A93B8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionButton(String letter, String optionText) {
    final isSelected = _selectedOption == optionText;
    
    Color borderColor = const Color(0xFF78A0FF).withValues(alpha: 0.22);
    Color? backgroundColor = const Color(0xFF161C34).withValues(alpha: 0.55);
    Color keyBgColor = const Color(0xFF00F0FF).withValues(alpha: 0.12);
    Color keyTextColor = const Color(0xFF00F0FF);

    if (_isLocked) {
      if (isSelected) {
        if (widget.mysteryMode) {
          // Mystery Selected Style
          borderColor = const Color(0xFF7A5CFF);
          backgroundColor = const Color(0xFF7A5CFF).withValues(alpha: 0.15);
          keyBgColor = const Color(0xFF7A5CFF).withValues(alpha: 0.2);
          keyTextColor = const Color(0xFF7A5CFF);
        } else {
          final isCorrect = _lastAnswerResult?.correct ?? false;
          if (isCorrect) {
            borderColor = const Color(0xFF00FF9C);
            backgroundColor = const Color(0xFF00FF9C).withValues(alpha: 0.15);
            keyBgColor = const Color(0xFF00FF9C).withValues(alpha: 0.2);
            keyTextColor = const Color(0xFF00FF9C);
          } else {
            borderColor = const Color(0xFFFF3D6E);
            backgroundColor = const Color(0xFFFF3D6E).withValues(alpha: 0.15);
            keyBgColor = const Color(0xFFFF3D6E).withValues(alpha: 0.2);
            keyTextColor = const Color(0xFFFF3D6E);
          }
        }
      }
    }

    return InkWell(
      onTap: _isLocked ? null : () => _submitAnswer(optionText),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
          boxShadow: isSelected && _isLocked && !widget.mysteryMode
              ? [
                  BoxShadow(
                    color: (_lastAnswerResult?.correct ?? false)
                        ? const Color(0xFF00FF9C).withValues(alpha: 0.2)
                        : const Color(0xFFFF3D6E).withValues(alpha: 0.2),
                    blurRadius: 10,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            // Option Key (A, B, C...)
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: keyBgColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: borderColor.withValues(alpha: 0.5)),
              ),
              child: Text(
                letter,
                style: GoogleFonts.orbitron(
                  color: keyTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Option Text
            Expanded(
              child: Text(
                optionText,
                style: GoogleFonts.rajdhani(
                  color: Colors.white.withValues(alpha: _isLocked && !isSelected ? 0.4 : 1.0),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackBanner() {
    final showMystery = widget.mysteryMode;
    final isCorrect = _lastAnswerResult?.correct ?? false;
    final pts = _lastAnswerResult?.pointsEarned ?? 0;

    Color color;
    String text;

    if (showMystery) {
      color = const Color(0xFF7A5CFF);
      text = '?? Resposta registrada. Continue jogando — o veredito vem no final.';
    } else if (isCorrect) {
      color = const Color(0xFF00FF9C);
      text = '✓ ACERTOU · +$pts pts';
    } else {
      color = const Color(0xFFFF3D6E);
      text = '✗ ERROU · +$pts pts';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161C34).withValues(alpha: 0.55),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildExhaustedState() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF101426).withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF78A0FF).withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '// CONCLUÍDO',
              style: GoogleFonts.orbitron(
                color: const Color(0xFF00FF9C),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _exhaustedMsg ?? 'Sem mais perguntas nesta categoria.',
              style: GoogleFonts.rajdhani(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _finishQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: const Color(0xFF00FF9C).withValues(alpha: 0.4),
                elevation: 8,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00FF9C), Color(0xFF00F0FF)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 52,
                  child: Text(
                    'VER RESULTADOS',
                    style: GoogleFonts.orbitron(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF101426).withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFF3D6E).withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '// ERRO DE SISTEMA',
              style: GoogleFonts.orbitron(
                color: const Color(0xFFFF3D6E),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMsg ?? 'Ocorreu um erro desconhecido.',
              style: GoogleFonts.rajdhani(
                color: const Color(0xFFFF3D6E),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF161C34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'TENTAR NOVAMENTE',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: Text(
                    'VOLTAR',
                    style: GoogleFonts.orbitron(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
