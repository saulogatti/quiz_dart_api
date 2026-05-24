import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quiz_result.dart';

/// Tela de exibição das métricas e pontuação consolidadas finais obtidas pelo jogador.
class ResultScreen extends StatelessWidget {
  /// O resultado consolidado final da sessão de jogo.
  final QuizResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060D),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: 100,
            left: 50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7A5CFF).withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00F0FF).withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // Title Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '// RELATÓRIO FINAL',
                          style: GoogleFonts.orbitron(
                            color: const Color(0xFFFF2BD6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sessão Concluída',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Giant Score Highlight (Glassmorphic)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101426).withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF00F0FF).withValues(alpha: 0.25)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'PONTUAÇÃO TOTAL',
                            style: GoogleFonts.rajdhani(
                              color: const Color(0xFF8A93B8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Glowing Score Text
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF00F0FF), Color(0xFF7A5CFF)],
                            ).createShader(bounds),
                            child: Text(
                              '${result.totalScore}',
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'pontos acumulados',
                            style: GoogleFonts.rajdhani(
                              color: const Color(0xFF8A93B8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistics Grid
                  Row(
                    children: [
                      _buildStatCard('ACERTOS', '${result.correctCount}', const Color(0xFF00FF9C)),
                      const SizedBox(width: 12),
                      _buildStatCard('ERROS', '${result.wrongCount}', const Color(0xFFFF3D6E)),
                      const SizedBox(width: 12),
                      _buildStatCard('RESPONDIDAS', '${result.totalAnswered}', Colors.white),
                    ],
                  ),

                  const Spacer(),

                  // Nova Sessão Button
                  ElevatedButton(
                    onPressed: () {
                      // Reset to Setup screen by popping until root or replacement
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: const Color(0xFFFF2BD6).withValues(alpha: 0.4),
                      elevation: 8,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF2BD6), Color(0xFF7A5CFF)],
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
                            const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'NOVA SESSÃO',
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF101426),
          border: Border.all(color: const Color(0xFF78A0FF).withValues(alpha: 0.18)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.orbitron(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                color: const Color(0xFF8A93B8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
