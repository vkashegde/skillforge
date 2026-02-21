import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_progress.dart';
import '../widgets/onboarding_footer.dart';

/// Step 1: Goal Selection page
class OnboardingGoalPage extends StatefulWidget {
  const OnboardingGoalPage({super.key});

  @override
  State<OnboardingGoalPage> createState() => _OnboardingGoalPageState();
}

class _OnboardingGoalPageState extends State<OnboardingGoalPage> {
  String? _selectedGoal;

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'faang',
      title: 'Ace FAANG Interviews',
      description: 'Master LeetCode patterns, optimization techniques, and system design fundamentals.',
      icon: Icons.business_center,
    ),
    GoalOption(
      id: 'master_dsa',
      title: 'Master Data Structures',
      description: 'Build a rock-solid foundation in arrays, linked lists, trees, and graph implementations.',
      icon: Icons.account_tree,
    ),
    GoalOption(
      id: 'competitive',
      title: 'Competitive Programming',
      description: 'Deep dive into advanced algorithms, speed-solving, and niche mathematical concepts.',
      icon: Icons.emoji_events,
    ),
    GoalOption(
      id: 'university',
      title: 'Learn for University',
      description: 'Excel in your academic Computer Science courses with aligned theory and practice.',
      icon: Icons.school,
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
              currentStep: 1,
              totalSteps: 4,
              stepTitle: 'GOAL SELECTION',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      'What is your primary goal?',
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
                      'We\'ll customize your DSA roadmap based on your objective to ensure you focus on the right patterns and algorithms.',
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Goal cards grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        final goal = _goals[index];
                        final isSelected = _selectedGoal == goal.id;
                        return _GoalCard(
                          goal: goal,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedGoal = goal.id;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    // Continue button
                    SizedBox(
                      width: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFA855F7),
                              Color(0xFF9333EA),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _selectedGoal != null
                              ? () {
                                  // Navigate to next step with selected goal
                                  context.push(
                                    '/onboarding/skill-level',
                                    extra: {'goal': _selectedGoal},
                                  );
                                }
                              : null,
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You can change your path at any time in settings.',
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const OnboardingFooter(),
          ],
        ),
      ),
    );
  }
}

class GoalOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  GoalOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _GoalCard extends StatelessWidget {
  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
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
          children: [
            Icon(
              goal.icon,
              color: const Color(0xFF9333EA),
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              goal.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                goal.description,
                style: const TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
