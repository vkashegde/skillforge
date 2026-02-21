import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_progress.dart';
import '../widgets/onboarding_navigation.dart';
import '../widgets/onboarding_footer.dart';

/// Step 3: Time Commitment page
class OnboardingTimeCommitmentPage extends StatefulWidget {
  final String? goal;
  final String? skillLevel;

  const OnboardingTimeCommitmentPage({
    super.key,
    this.goal,
    this.skillLevel,
  });

  @override
  State<OnboardingTimeCommitmentPage> createState() =>
      _OnboardingTimeCommitmentPageState();
}

class _OnboardingTimeCommitmentPageState
    extends State<OnboardingTimeCommitmentPage> {
  String? _selectedTimeCommitment;

  final List<TimeCommitmentOption> _timeOptions = [
    TimeCommitmentOption(
      id: '15-30',
      title: '15-30 mins',
      subtitle: 'Casual Pace',
      description: 'Best for a quick daily refresh and consistency.',
      icon: Icons.local_cafe,
      iconColor: Colors.green,
    ),
    TimeCommitmentOption(
      id: '30-60',
      title: '30-60 mins',
      subtitle: 'Steady Progress',
      description: 'The most effective pace for long-term retention.',
      icon: Icons.timer,
      iconColor: Colors.blue,
      isPopular: true,
    ),
    TimeCommitmentOption(
      id: '1-2',
      title: '1-2 hours',
      subtitle: 'Serious Study',
      description: 'Deep dive into complex algorithms and logic.',
      icon: Icons.fitness_center,
      iconColor: Colors.orange,
    ),
    TimeCommitmentOption(
      id: '2+',
      title: '2+ hours',
      subtitle: 'Intensive Mode',
      description: 'Accelerated path for upcoming interview prep.',
      icon: Icons.local_fire_department,
      iconColor: Colors.red,
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
              currentStep: 3,
              totalSteps: 4,
              stepTitle: 'TIME COMMITMENT',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      'How much time can you commit daily?',
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
                      'We\'ll tailor your roadmap and daily challenges to fit your schedule and learning velocity.',
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Time commitment cards grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _timeOptions.length,
                      itemBuilder: (context, index) {
                        final option = _timeOptions[index];
                        final isSelected = _selectedTimeCommitment == option.id;
                        return _TimeCommitmentCard(
                          option: option,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedTimeCommitment = option.id;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            OnboardingNavigation(
              onBack: () => context.pop(),
              onContinue: _selectedTimeCommitment != null
                  ? () {
                      context.push(
                        '/onboarding/summary',
                        extra: {
                          'goal': widget.goal,
                          'skillLevel': widget.skillLevel,
                          'timeCommitment': _selectedTimeCommitment,
                        },
                      );
                    }
                  : null,
            ),
            const OnboardingFooter(),
          ],
        ),
      ),
    );
  }
}

class TimeCommitmentOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isPopular;

  TimeCommitmentOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.isPopular = false,
  });
}

class _TimeCommitmentCard extends StatelessWidget {
  final TimeCommitmentOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeCommitmentCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E1E2E)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9333EA)
                : const Color(0xFF2A2A2A),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: option.iconColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        option.icon,
                        color: option.iconColor,
                        size: 28,
                      ),
                    ),
                    if (option.isPopular) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9333EA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'POPULAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  option.subtitle,
                  style: const TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    option.description,
                    style: const TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            // Radio button in top-right
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF9333EA)
                        : const Color(0xFF6B6B6B),
                    width: 2,
                  ),
                  color: isSelected
                      ? const Color(0xFF9333EA)
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
