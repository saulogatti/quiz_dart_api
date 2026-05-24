import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quiz_api_client.dart';
import 'quiz_play_screen.dart';

/// Tela de configuração inicial e identificação do jogador.
///
/// Permite definir o e-mail, escolher a categoria das perguntas, habilitar/desabilitar
/// o Modo Mistério e parametrizar o IP da API do servidor de quiz.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _emailController = TextEditingController();
  final _urlController = TextEditingController();
  String _selectedCategory = 'generalKnowledge';
  bool _mysteryMode = false;
  bool _showSettings = false;

  final Map<String, String> _categories = {
    'generalKnowledge': 'Conhecimento Geral',
    'geography': 'Geografia',
    'historyFashion': 'História & Moda',
    'popCultureMusic': 'Pop & Música',
  };

  @override
  void initState() {
    super.initState();
    // Smart default URL detection
    if (kIsWeb) {
      _urlController.text = 'http://localhost:5469/api/v2';
    } else if (Platform.isAndroid) {
      _urlController.text = 'http://10.0.2.2:5469/api/v2';
    } else {
      _urlController.text = 'http://localhost:5469/api/v2';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  /// Valida as entradas do formulário e inicia o quiz navegando para a [QuizPlayScreen].
  void _startQuiz() {
    final email = _emailController.text.trim();
    final baseUrl = _urlController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe seu e-mail para começar.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O endereço da API não pode estar vazio.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final apiClient = QuizApiClient(baseUrl: baseUrl);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPlayScreen(
          apiClient: apiClient,
          email: email,
          category: _selectedCategory,
          categoryLabel: _categories[_selectedCategory]!,
          mysteryMode: _mysteryMode,
        ),
      ),
    );
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
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF2BD6).withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7A5CFF).withValues(alpha: 0.08),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // Header/Logo
                  Center(
                    child: Column(
                      children: [
                        // Brand Icon (Hexagon shape with glow)
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00F0FF), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bolt,
                            color: Color(0xFF00F0FF),
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.orbitron(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                            children: const [
                              TextSpan(
                                text: 'QUIZ',
                                style: TextStyle(color: Color(0xFF00F0FF)),
                              ),
                              TextSpan(
                                text: '::',
                                style: TextStyle(color: Colors.white24),
                              ),
                              TextSpan(
                                text: 'NEON',
                                style: TextStyle(color: Color(0xFFFF2BD6)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v2 · neural quiz engine',
                          style: GoogleFonts.rajdhani(
                            color: const Color(0xFF8A93B8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Main Config Card (Glassmorphic)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101426).withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF78A0FF).withValues(alpha: 0.22),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '// IDENTIFICAÇÃO',
                            style: GoogleFonts.orbitron(
                              color: const Color(0xFF00F0FF),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Inicializar Sessão',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email Input
                          Text(
                            'E-MAIL DO JOGADOR',
                            style: GoogleFonts.rajdhani(
                              color: const Color(0xFF8A93B8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'player@neon.io',
                              hintStyle: const TextStyle(color: Colors.white30),
                              fillColor: const Color(0xFF161C34).withValues(alpha: 0.55),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color(0xFF78A0FF).withValues(alpha: 0.22),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF00F0FF)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Category Selection
                          Text(
                            'CATEGORIA',
                            style: GoogleFonts.rajdhani(
                              color: const Color(0xFF8A93B8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _categories.entries.map((entry) {
                              final isActive = _selectedCategory == entry.key;
                              return ChoiceChip(
                                label: Text(entry.value),
                                selected: isActive,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCategory = entry.key;
                                    });
                                  }
                                },
                                labelStyle: GoogleFonts.rajdhani(
                                  color: isActive ? Colors.black : const Color(0xFF8A93B8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                selectedColor: const Color(0xFF00F0FF),
                                backgroundColor: const Color(0xFF161C34).withValues(alpha: 0.55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  side: BorderSide(
                                    color: isActive
                                        ? Colors.transparent
                                        : const Color(0xFF78A0FF).withValues(alpha: 0.22),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Mystery Mode Toggle Card
                          InkWell(
                            onTap: () {
                              setState(() {
                                _mysteryMode = !_mysteryMode;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161C34).withValues(alpha: 0.55),
                                border: Border.all(
                                  color: const Color(0xFF78A0FF).withValues(alpha: 0.22),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'MODO MISTÉRIO',
                                          style: GoogleFonts.rajdhani(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Esconde se acertou/errou as respostas — revela só no final.',
                                          style: GoogleFonts.rajdhani(
                                            color: const Color(0xFF8A93B8),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: _mysteryMode,
                                    activeThumbColor: const Color(0xFFFF2BD6),
                                    activeTrackColor: const Color(0xFF7A5CFF).withValues(alpha: 0.5),
                                    inactiveThumbColor: const Color(0xFF8A93B8),
                                    inactiveTrackColor: Colors.black38,
                                    onChanged: (val) {
                                      setState(() {
                                        _mysteryMode = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Start Button
                          ElevatedButton(
                            onPressed: _startQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: const Color(0xFF00F0FF).withValues(alpha: 0.4),
                              elevation: 8,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00F0FF), Color(0xFF7A5CFF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(minHeight: 52),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'INICIAR QUIZ',
                                      style: GoogleFonts.orbitron(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Connection Settings (Collapsible)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showSettings = !_showSettings;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showSettings ? Icons.keyboard_arrow_up : Icons.settings,
                            color: const Color(0xFF8A93B8),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showSettings
                                ? 'Esconder Configurações de API'
                                : 'Configurações de Conexão com API',
                            style: GoogleFonts.rajdhani(
                              color: const Color(0xFF8A93B8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_showSettings) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF101426).withValues(alpha: 0.5),
                          border: Border.all(
                            color: const Color(0xFF78A0FF).withValues(alpha: 0.12),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'BASE URL DA API V2',
                              style: GoogleFonts.rajdhani(
                                color: const Color(0xFF8A93B8),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _urlController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'monospace',
                              ),
                              decoration: InputDecoration(
                                hintText: 'http://10.0.2.2:5469/api/v2',
                                fillColor: const Color(0xFF161C34).withValues(alpha: 0.3),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nota: Se estiver rodando no Emulador Android, use o IP "http://10.0.2.2:5469/api/v2" para referenciar a sua máquina host.',
                              style: GoogleFonts.rajdhani(
                                color: const Color(0xFF8A93B8).withValues(alpha: 0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// We can use BackdropFilter inside our stacks to achieve the authentic glassmorphic blur.
// Let's write the code using standard BackdropFilter widgets which are built into Flutter.
