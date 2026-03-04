import 'package:flutter/material.dart';
import '../models/detection_result_model.dart';
import '../config/app_config.dart';

// ── Behavior Knowledge Base ───────────────────────────────────────────────────

class _BehaviorInfo {
  final String description;
  final String clinicalSignificance;
  final List<String> recommendations;
  final IconData icon;

  const _BehaviorInfo({
    required this.description,
    required this.clinicalSignificance,
    required this.recommendations,
    required this.icon,
  });
}

const Map<String, _BehaviorInfo> _behaviorKnowledge = {
  'Hand Flapping': _BehaviorInfo(
    description:
        'Hand flapping involves rapid, repetitive flapping or waving movements of the hands and wrists. '
        'It is commonly observed during moments of excitement, stress, or sensory overload in children with ASD.',
    clinicalSignificance:
        'Hand flapping is one of the most frequently observed stereotyped motor behaviors in ASD. '
        'It may serve as a self-regulatory mechanism for managing emotional states or sensory input.',
    recommendations: [
      'Consult a licensed occupational therapist (OT) for sensory integration therapy',
      'Consider Applied Behavior Analysis (ABA) to identify triggering contexts',
      'Provide alternative sensory outlets such as fidget tools or stress balls',
      'Document frequency and contexts for clinical follow-up',
    ],
    icon: Icons.back_hand,
  ),
  'Head Banging': _BehaviorInfo(
    description:
        'Head banging refers to repetitive striking of the head against a surface, object, or the child\'s own hands. '
        'This behavior can occur during frustration, sleep transitions, or as a form of sensory seeking.',
    clinicalSignificance:
        'Head banging requires immediate clinical attention as it can cause physical injury. '
        'It may indicate pain, communication difficulties, or extreme sensory dysregulation.',
    recommendations: [
      'Seek immediate evaluation by a developmental pediatrician or child psychologist',
      'Ensure the environment is padded to prevent physical injury',
      'Rule out underlying medical causes (e.g., ear pain, headaches)',
      'Behavioral intervention through ABA therapy is strongly recommended',
      'Consider communication augmentation strategies if verbal communication is limited',
    ],
    icon: Icons.sports_martial_arts,
  ),
  'Head Nodding': _BehaviorInfo(
    description:
        'Head nodding involves repetitive up-and-down or side-to-side movements of the head. '
        'This vestibular-seeking behavior may occur during idle periods or as a self-stimulatory behavior.',
    clinicalSignificance:
        'Repetitive head nodding can indicate vestibular sensory seeking. '
        'When persistent, it warrants assessment to differentiate from neurological conditions.',
    recommendations: [
      'Refer to a pediatric neurologist to rule out neurological causes',
      'Occupational therapy with a vestibular sensory integration focus is recommended',
      'Provide alternative vestibular stimulation activities (swings, rocking chairs)',
      'Monitor frequency and duration and report to the clinical team',
    ],
    icon: Icons.rotate_90_degrees_ccw,
  ),
  'Spinning': _BehaviorInfo(
    description:
        'Spinning involves repetitive rotational movements of the child\'s body in circles. '
        'It is a form of vestibular stimulation commonly observed in children with ASD and sensory processing differences.',
    clinicalSignificance:
        'Spinning is a self-stimulatory behavior that reflects atypical vestibular processing. '
        'Children who spin for extended periods may have significantly elevated sensory thresholds.',
    recommendations: [
      'Evaluate vestibular and proprioceptive processing with an occupational therapist',
      'Channel spinning needs into therapeutic activities such as supervised spinning chairs',
      'Implement structured movement breaks throughout the day',
      'Observe for signs of dizziness or disorientation following episodes',
    ],
    icon: Icons.rotate_right,
  ),
  'Atypical Hand Movements': _BehaviorInfo(
    description:
        'Atypical hand movements include unusual, repetitive finger or hand gestures that fall outside '
        'typical developmental motor patterns, such as finger flicking, posturing, or unusual hand positioning.',
    clinicalSignificance:
        'Atypical hand movements may reflect fine motor developmental differences or stereotyped motor patterns '
        'associated with ASD. Early fine motor intervention can significantly improve functional outcomes.',
    recommendations: [
      'Fine motor assessment by a certified occupational therapist is recommended',
      'Engage the child in structured fine motor activities (puzzles, clay, drawing)',
      'Explore the functional purpose of the movements for behavioral intervention planning',
      'Include findings in the comprehensive developmental assessment report',
    ],
    icon: Icons.pan_tool_alt,
  ),
  'Normal': _BehaviorInfo(
    description:
        'No Restricted or Repetitive Behaviors were detected in the analyzed video. '
        'The child\'s observed movements appear to fall within the typical developmental range for their age group.',
    clinicalSignificance:
        'A normal classification indicates the absence of detectable RRB patterns in this video segment. '
        'This should be interpreted alongside a full clinical evaluation as part of a comprehensive developmental assessment.',
    recommendations: [
      'Continue regular developmental monitoring as per clinical schedule',
      'A single video analysis does not replace comprehensive clinical evaluation',
      'Maintain records of all observations for longitudinal tracking',
      'Consult your clinical team if behavioral concerns arise in other settings',
    ],
    icon: Icons.check_circle,
  ),
};

// ── Results Screen ────────────────────────────────────────────────────────────

class ResultsScreen extends StatelessWidget {
  final DetectionResult? detectionResult;

  const ResultsScreen({super.key, this.detectionResult});

  @override
  Widget build(BuildContext context) {
    if (detectionResult == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        appBar: AppBar(
          title: const Text(
            'Detection Results',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF1A237E),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_rounded, size: 64, color: Color(0xFF90A4AE)),
              SizedBox(height: 16),
              Text(
                'No results available',
                style: TextStyle(fontSize: 18, color: Color(0xFF546E7A)),
              ),
            ],
          ),
        ),
      );
    }

    final result = detectionResult!;
    final isDetected = result.detected;
    final headerGradient = isDetected
        ? const [Color(0xFFE65100), Color(0xFFFF8F00)]
        : const [Color(0xFF1B5E20), Color(0xFF43A047)];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        slivers: [
          // ── Hero Result Header ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: isDetected
                ? const Color(0xFFE65100)
                : const Color(0xFF1B5E20),
            title: const Text(
              'Detection Results',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                tooltip: 'Share Report',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality coming soon'),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: headerGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDetected
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isDetected
                              ? 'RRB Behavior Detected'
                              : 'No RRB Detected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (result.primaryBehavior != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Primary: ${result.primaryBehavior}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        if (result.confidence != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Overall Confidence: ${(result.confidence! * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDetected
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDetected
                            ? const Color(0xFFFFCC02)
                            : const Color(0xFFA5D6A7),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isDetected
                              ? Icons.info_rounded
                              : Icons.verified_rounded,
                          color: isDetected
                              ? const Color(0xFFE65100)
                              : const Color(0xFF2E7D32),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isDetected
                                ? 'The AI model identified ${result.behaviors.length} RRB class${result.behaviors.length > 1 ? "es" : ""} in this video. '
                                      'Please review each detected behavior and follow the clinical recommendations below.'
                                : 'No Restricted or Repetitive Behaviors were detected in this video. '
                                      'Continued monitoring is recommended as part of comprehensive clinical assessment.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDetected
                                  ? const Color(0xFF6D3000)
                                  : const Color(0xFF1B5E20),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Detected Behaviors with clinical info
                  if (result.behaviors.isNotEmpty) ...[
                    _ResultSectionTitle(
                      title: 'Detected Behavior Classes',
                      subtitle:
                          '${result.behaviors.length} class${result.behaviors.length > 1 ? "es" : ""} identified',
                      icon: Icons.category_rounded,
                    ),
                    const SizedBox(height: 12),
                    ...result.behaviors.asMap().entries.map(
                      (entry) => _BehaviorDetailCard(
                        behavior: entry.value,
                        rank: entry.key + 1,
                        total: result.behaviors.length,
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],

                  // Video Metadata
                  _ResultSectionTitle(
                    title: 'Video Analysis Metadata',
                    subtitle: 'Technical details of the analyzed video',
                    icon: Icons.analytics_rounded,
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
                        children: [
                          _MetaRow(
                            icon: Icons.timer_outlined,
                            label: 'Video Duration',
                            value:
                                '${result.metadata.duration.toStringAsFixed(1)} sec',
                            valueColor: const Color(0xFF1565C0),
                          ),
                          const Divider(height: 20),
                          _MetaRow(
                            icon: Icons.speed_rounded,
                            label: 'Frame Rate',
                            value: '${result.metadata.fps} FPS',
                            valueColor: const Color(0xFF7B1FA2),
                          ),
                          const Divider(height: 20),
                          _MetaRow(
                            icon: Icons.layers_rounded,
                            label: 'Sequences Analyzed',
                            value: '${result.metadata.sequencesAnalyzed}',
                            valueColor: const Color(0xFF2E7D32),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Clinical Disclaimer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCE93D8)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.medical_information_rounded,
                          color: Color(0xFF7B1FA2),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Clinical Note: These results are generated by an AI model and should be used as a supplementary tool only. '
                            'A formal diagnosis must be made by a qualified healthcare professional following a comprehensive clinical evaluation.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A148C),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Back to Home Button
                  Material(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFF1A237E),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/home', (route) => false),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_rounded, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Back to Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

class _ResultSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ResultSectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1976D2), size: 22),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A237E),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF78909C)),
            ),
          ],
        ),
      ],
    );
  }
}

class _BehaviorDetailCard extends StatefulWidget {
  final BehaviorDetection behavior;
  final int rank;
  final int total;

  const _BehaviorDetailCard({
    required this.behavior,
    required this.rank,
    required this.total,
  });

  @override
  State<_BehaviorDetailCard> createState() => _BehaviorDetailCardState();
}

class _BehaviorDetailCardState extends State<_BehaviorDetailCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(
      AppConfig.categoryColors[widget.behavior.behavior] ?? 0xFF2196F3,
    );
    final info = _behaviorKnowledge[widget.behavior.behavior];
    final confidencePct = (widget.behavior.confidence * 100).toStringAsFixed(1);
    final isPrimary = widget.rank == 1 && widget.total > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary ? color : const Color(0xFFDDE3F0),
          width: isPrimary ? 2 : 1,
        ),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        info?.icon ?? Icons.psychology_alt,
                        color: color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.behavior.behavior,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ),
                              if (isPrimary)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'PRIMARY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Confidence: $confidencePct%  ·  ${widget.behavior.occurrences} occurrence${widget.behavior.occurrences != 1 ? "s" : ""}  ·  ${widget.behavior.totalDuration.toStringAsFixed(1)}s',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF78909C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Confidence Bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: widget.behavior.confidence,
                          backgroundColor: const Color(0xFFECEFF1),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$confidencePct%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),

                // Stats Row
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatChip(
                      label: 'Occurrences',
                      value: '${widget.behavior.occurrences}',
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: 'Total Duration',
                      value:
                          '${widget.behavior.totalDuration.toStringAsFixed(1)}s',
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expandable Clinical Info
          if (info != null) ...[
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.06),
                  border: Border(
                    top: BorderSide(color: color.withValues(alpha: 0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      color: color,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Clinical Information & Recommendations',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: color,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    _ClinicalSection(
                      icon: Icons.description_rounded,
                      title: 'What is this?',
                      color: color,
                      child: Text(
                        info.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF37474F),
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Clinical Significance
                    _ClinicalSection(
                      icon: Icons.biotech_rounded,
                      title: 'Clinical Significance',
                      color: color,
                      child: Text(
                        info.clinicalSignificance,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF37474F),
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Recommendations
                    _ClinicalSection(
                      icon: Icons.assignment_turned_in_rounded,
                      title: 'Recommended Actions',
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: info.recommendations
                            .map(
                              (rec) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        rec,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF37474F),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _ClinicalSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _ClinicalSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _MetaRow({
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
