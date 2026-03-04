import 'package:flutter/material.dart';

/// Home Screen - Main dashboard
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        slivers: [
          // ── Gradient Hero AppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.psychology_alt,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RRB Detection',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'AI-Powered Behavioral Analysis',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Text(
                            'Detect Restricted & Repetitive Behaviors in children through clinical observation videos.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'RRB Detection',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF1A237E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // ── Body Content ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // What is RRB?
                  _SectionTitle(
                    title: 'What is RRB?',
                    icon: Icons.help_outline,
                  ),
                  const SizedBox(height: 10),
                  const _InfoCard(
                    icon: Icons.info_rounded,
                    iconColor: Color(0xFF1976D2),
                    bgColor: Color(0xFFE3F2FD),
                    borderColor: Color(0xFF90CAF9),
                    content:
                        'Restricted and Repetitive Behaviors (RRBs) are a hallmark characteristic observed in children with Autism Spectrum Disorder (ASD). '
                        'These behaviors include repetitive body movements, insistence on sameness, and highly restricted interests.\n\n'
                        'Early identification of RRBs is crucial for timely intervention and support. This AI-powered tool analyzes clinical '
                        'observation videos to automatically detect and classify RRB patterns in children aged 2–6 years.',
                  ),
                  const SizedBox(height: 24),

                  // How it Works
                  _SectionTitle(
                    title: 'How It Works',
                    icon: Icons.account_tree_outlined,
                  ),
                  const SizedBox(height: 12),
                  isWide
                      ? Row(
                          children: [
                            Expanded(
                              child: _StepCard(
                                step: '1',
                                icon: Icons.video_call_rounded,
                                title: 'Record or Upload',
                                desc:
                                    'Record a clinical observation video using your device camera or upload an existing video file.',
                                color: const Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StepCard(
                                step: '2',
                                icon: Icons.memory_rounded,
                                title: 'AI Analysis',
                                desc:
                                    'Our deep learning model analyzes every frame sequence to identify behavioral patterns with high precision.',
                                color: const Color(0xFF7B1FA2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StepCard(
                                step: '3',
                                icon: Icons.bar_chart_rounded,
                                title: 'View Results',
                                desc:
                                    'Get a detailed clinical report with detected behavior classes, confidence scores, and professional recommendations.',
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _StepCard(
                              step: '1',
                              icon: Icons.video_call_rounded,
                              title: 'Record or Upload',
                              desc:
                                  'Record a clinical observation video using your device camera or upload an existing video file.',
                              color: const Color(0xFF1976D2),
                            ),
                            const SizedBox(height: 12),
                            _StepCard(
                              step: '2',
                              icon: Icons.memory_rounded,
                              title: 'AI Analysis',
                              desc:
                                  'Our deep learning model analyzes every frame sequence to identify behavioral patterns with high precision.',
                              color: const Color(0xFF7B1FA2),
                            ),
                            const SizedBox(height: 12),
                            _StepCard(
                              step: '3',
                              icon: Icons.bar_chart_rounded,
                              title: 'View Results',
                              desc:
                                  'Get a detailed clinical report with detected behavior classes, confidence scores, and professional recommendations.',
                              color: const Color(0xFF2E7D32),
                            ),
                          ],
                        ),
                  const SizedBox(height: 24),

                  // Detectable Behaviors
                  _SectionTitle(
                    title: 'Detectable Behavior Classes',
                    icon: Icons.category_rounded,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _BehaviorChip(
                        label: 'Hand Flapping',
                        color: Color(0xFFE74C3C),
                        icon: Icons.back_hand,
                      ),
                      _BehaviorChip(
                        label: 'Head Banging',
                        color: Color(0xFFE67E22),
                        icon: Icons.sports_martial_arts,
                      ),
                      _BehaviorChip(
                        label: 'Head Nodding',
                        color: Color(0xFFF39C12),
                        icon: Icons.rotate_90_degrees_ccw,
                      ),
                      _BehaviorChip(
                        label: 'Spinning',
                        color: Color(0xFF9B59B6),
                        icon: Icons.rotate_right,
                      ),
                      _BehaviorChip(
                        label: 'Atypical Hand Movements',
                        color: Color(0xFF3498DB),
                        icon: Icons.pan_tool_alt,
                      ),
                      _BehaviorChip(
                        label: 'Normal',
                        color: Color(0xFF2ECC71),
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // START DETECTION CTA
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF1976D2,
                          ).withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.of(context).pushNamed('/record'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 22,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 18),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start RRB Detection',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Upload or record a video to begin AI analysis',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key Specs
                  _SectionTitle(
                    title: 'Detection Specifications',
                    icon: Icons.tune_rounded,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFDDE3F0)),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          _SpecRow(
                            icon: Icons.timer_outlined,
                            label: 'Minimum Video Duration',
                            value: '10 seconds',
                            valueColor: Color(0xFF2E7D32),
                          ),
                          Divider(height: 20),
                          _SpecRow(
                            icon: Icons.hourglass_top_rounded,
                            label: 'Maximum Video Duration',
                            value: '5 minutes',
                            valueColor: Color(0xFF1565C0),
                          ),
                          Divider(height: 20),
                          _SpecRow(
                            icon: Icons.verified_rounded,
                            label: 'Confidence Threshold',
                            value: '≥ 70%',
                            valueColor: Color(0xFF7B1FA2),
                          ),
                          Divider(height: 20),
                          _SpecRow(
                            icon: Icons.av_timer_rounded,
                            label: 'Min. Detection Duration',
                            value: '3 seconds',
                            valueColor: Color(0xFFE65100),
                          ),
                          Divider(height: 20),
                          _SpecRow(
                            icon: Icons.videocam_rounded,
                            label: 'Recommended Resolution',
                            value: '720p / 30 FPS',
                            valueColor: Color(0xFF1976D2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Clinical Disclaimer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFE082)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFF9A825),
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Clinical Disclaimer: This tool is designed to assist healthcare professionals and researchers. Results should be interpreted alongside clinical evaluation by a qualified professional. This application is not a substitute for a formal medical diagnosis.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6D4C0E),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1976D2), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final String content;
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF37474F),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE3F0)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: color, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF546E7A),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BehaviorChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _BehaviorChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF78909C), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF455A64)),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
