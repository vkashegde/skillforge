import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_progress.dart';
import '../widgets/onboarding_navigation.dart';
import '../widgets/onboarding_footer.dart';

/// Step 2: Skill Level Selection page
class OnboardingSkillLevelPage extends StatefulWidget {
  final String? goal;

  const OnboardingSkillLevelPage({
    super.key,
    this.goal,
  });

  @override
  State<OnboardingSkillLevelPage> createState() =>
      _OnboardingSkillLevelPageState();
}

class _OnboardingSkillLevelPageState extends State<OnboardingSkillLevelPage> {
  String? _selectedSkillLevel;

  final List<SkillLevelOption> _skillLevels = [
    SkillLevelOption(
      id: 'beginner',
      title: 'Beginner',
      description:
          'New to DSA. I\'m just starting my journey. I want to learn the fundamentals from scratch.',
      tag: 'Starting point →',
      icon: Icons.eco,
      iconColor: Colors.green,
    ),
    SkillLevelOption(
      id: 'intermediate',
      title: 'Intermediate',
      description:
          'Know basics, need practice. I understand arrays and strings but struggle with DP or Graphs.',
      tag: 'Most common →',
      icon: Icons.settings,
      iconColor: Colors.blue,
    ),
    SkillLevelOption(
      id: 'advanced',
      title: 'Advanced',
      description:
          'Looking for complex problems. I want to master hard-level LeetCode and competitive programming.',
      tag: 'Peak performance →',
      icon: Icons.bolt,
      iconColor: const Color(0xFF9333EA),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(),
            const OnboardingProgress(
              currentStep: 2,
              totalSteps: 4,
              stepTitle: 'SKILL LEVEL SELECTION',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      'What is your current DSA experience?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    const Text(
                      'Select the level that best describes your knowledge. We\'ll tailor your learning path and mentor\'s difficulty accordingly.',
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Skill level cards
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _skillLevels.map((skillLevel) {
                          final isSelected = _selectedSkillLevel == skillLevel.id;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: _SkillLevelCard(
                                skillLevel: skillLevel,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedSkillLevel = skillLevel.id;
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            OnboardingNavigation(
              onBack: () => context.pop(),
              onContinue: _selectedSkillLevel != null
                  ? () {
                      context.push(
                        '/onboarding/time-commitment',
                        extra: {
                          'goal': widget.goal,
                          'skillLevel': _selectedSkillLevel,
                        },
                      );
                    }
                  : null,
              canSkip: true,
              onSkip: () {
                context.push(
                  '/onboarding/time-commitment',
                  extra: {
                    'goal': widget.goal,
                    'skillLevel': null,
                  },
                );
              },
            ),
            const OnboardingFooter(),
          ],
        ),
      ),
    );
  }
}

class SkillLevelOption {
  final String id;
  final String title;
  final String description;
  final String tag;
  final IconData icon;
  final Color iconColor;

  SkillLevelOption({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.icon,
    required this.iconColor,
  });
}

class _SkillLevelCard extends StatelessWidget {
  final SkillLevelOption skillLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const _SkillLevelCard({
    required this.skillLevel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9333EA)
                : const Color(0xFF2A2A2A),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              skillLevel.icon,
              color: skillLevel.iconColor,
              size: 48,
            ),
            const SizedBox(height: 24),
            Text(
              skillLevel.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                skillLevel.description,
                style: const TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              skillLevel.tag,
              style: const TextStyle(
                color: Color(0xFF9333EA),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
