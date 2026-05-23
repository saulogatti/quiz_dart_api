import '../model/question_model.dart';

final List<Map<String, dynamic>> questions = [
  QuestionModelMock(
    id: 1,
    category: 'generalKnowledge',
    question: 'Quantos fusos horários existem na Rússia?',
    answer: '11',
  ).toMap(),
  QuestionModelMock(
    id: 2,
    category: 'generalKnowledge',
    question: 'Qual é a flor nacional do Japão?',
    answer: 'flor de cerejeira',
  ).toMap(),
  QuestionModelMock(
    id: 3,
    category: 'generalKnowledge',
    question: 'Quantas tiras há na bandeira dos Estados Unidos?',
    answer: '13',
  ).toMap(),
  QuestionModelMock(
    id: 4,
    category: 'generalKnowledge',
    question: 'Qual é o animal nacional da Austrália?',
    answer: 'canguru vermelho',
  ).toMap(),
  QuestionModelMock(
    id: 5,
    category: 'generalKnowledge',
    question: 'Quantos dias são necessários para a Terra orbitar o sol?',
    answer: '365',
  ).toMap(),
  QuestionModelMock(
    id: 6,
    category: 'generalKnowledge',
    question:
        'Qual dos impérios a seguir não possui um idioma escrito: Inca, Azteca, Egípcio ou Romano?',
    answer: 'inca',
  ).toMap(),
  QuestionModelMock(
    id: 7,
    category: 'generalKnowledge',
    question: 'Até 1923, como era chamada a cidade turca de Istambul?',
    answer: 'constantinopla',
  ).toMap(),
  QuestionModelMock(
    id: 8,
    category: 'geography',
    question: 'Qual país tem mais ilhas no mundo?',
    answer: 'suécia',
  ).toMap(),
  QuestionModelMock(
    id: 9,
    category: 'geography',
    question: 'Qual é o menor país do mundo?',
    answer: 'vaticano',
  ).toMap(),
  QuestionModelMock(
    id: 10,
    category: 'geography',
    question: 'Qual a capital do Canadá?',
    answer: 'ottawa',
  ).toMap(),
  QuestionModelMock(
    id: 11,
    category: 'geography',
    question: 'Qual é a maior (não mais alta) cadeia de montanhas do mundo?',
    answer: 'andes',
  ).toMap(),
  QuestionModelMock(
    id: 12,
    category: 'geography',
    question: 'Onde é o lugar natural mais baixo do planeta Terra?',
    answer: 'fossa das marianas',
  ).toMap(),
  QuestionModelMock(
    id: 13,
    category: 'geography',
    question: 'Qual é o rio mais longo do mundo?',
    answer: 'rio nilo',
  ).toMap(),
  QuestionModelMock(
    id: 14,
    category: 'geography',
    question: 'Qual é a gíria usada pelos locais para se referir a cidade de Nova York?',
    answer: 'gotham',
  ).toMap(),
  QuestionModelMock(
    id: 15,
    category: 'geography',
    question: 'Qual é a série de livros mais vendida do século 21?',
    answer: 'harry potter',
  ).toMap(),
  QuestionModelMock(
    id: 16,
    category: 'geography',
    question: 'Qual idioma tem o maior número de palavras (de acordo com dicionários)?',
    answer: 'inglês',
  ).toMap(),
  QuestionModelMock(
    id: 17,
    category: 'geography',
    question: 'Qual famoso grafiteiro nasceu em Bristol?',
    answer: 'banksy',
  ).toMap(),
  QuestionModelMock(
    id: 18,
    category: 'geography',
    question: 'O artista norueguês Edvard Munch é famoso por pintar qual peça icônica?',
    answer: 'o grito',
  ).toMap(),
  QuestionModelMock(
    id: 19,
    category: 'geography',
    question: 'Qual artista pintou o teto da Capela Sistina, em Roma?',
    answer: 'michelangelo',
  ).toMap(),
  QuestionModelMock(
    id: 20,
    category: 'historyFashion',
    question: 'Quando o metrô de Londres foi inaugurado?',
    answer: '1863',
  ).toMap(),
  QuestionModelMock(
    id: 21,
    category: 'historyFashion',
    question: 'Quem inventou o WWW (World Wide Web), e quando?',
    answer: 'tim berners-lee',
  ).toMap(),
  QuestionModelMock(
    id: 22,
    category: 'historyFashion',
    question: 'Quem inventou o icônico Little Black Dress?',
    answer: 'coco chanel',
  ).toMap(),
  QuestionModelMock(
    id: 23,
    category: 'historyFashion',
    question: 'O que aconteceu em 20 de Julho de 1969?',
    answer: 'apollo 11 pousou na lua',
  ).toMap(),
  QuestionModelMock(
    id: 24,
    category: 'historyFashion',
    question: 'Quando foi a primeira publicação da Vogue: 1892, 1960, 2000?',
    answer: '1892',
  ).toMap(),
  QuestionModelMock(
    id: 25,
    category: 'popCultureMusic',
    question: 'De onde é Billie Eilish?',
    answer: 'los angeles',
  ).toMap(),
  QuestionModelMock(
    id: 26,
    category: 'popCultureMusic',
    question: 'De qual cidade vieram os Beatles?',
    answer: 'liverpool',
  ).toMap(),
  QuestionModelMock(
    id: 27,
    category: 'popCultureMusic',
    question: 'Qual é a música mais tocada no Spotify de todos os tempos até agora?',
    answer: 'ed sheeran, the shape of you',
  ).toMap(),
  QuestionModelMock(
    id: 28,
    category: 'popCultureMusic',
    question: 'Qual foi o álbum mais tocado no Spotify em 2019?',
    answer: 'when we fall asleep, where do we go? billie eilish',
  ).toMap(),
  QuestionModelMock(
    id: 29,
    category: 'popCultureMusic',
    question: 'Quantas teclas há em um piano clássico?',
    answer: '88',
  ).toMap(),
  QuestionModelMock(
    id: 30,
    category: 'popCultureMusic',
    question: 'Qual famosa banda americana era chamada originalmente de “Kara’s Flowers”?',
    answer: 'maroon 5',
  ).toMap(),
];

class QuestionModelMock extends QuestionModel {
  String category;
  QuestionModelMock({
    required super.id,

    required super.question,
    required super.answer,
    required this.category,
  }) : super(points: 10);

  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category, 'question': question, 'answer': answer, 'points': points};
  }
}
