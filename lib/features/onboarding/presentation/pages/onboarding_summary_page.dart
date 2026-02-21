import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/utils/auth_helper.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_progress.dart';
import '../widgets/onboarding_footer.dart';

/// Step 4: Plan Summary page
class OnboardingSummaryPage extends StatefulWidget {
  final String? goal;
  final String? skillLevel;
  final String? timeCommitment;

  const OnboardingSummaryPage({
    super.key,
    this.goal,
    this.skillLevel,
    this.timeCommitment,
  });

  @override
  State<OnboardingSummaryPage> createState() => _OnboardingSummaryPageState();
}

class _OnboardingSummaryPageState extends State<OnboardingSummaryPage> {
  final _profileRepository = di.sl<ProfileRepository>();
  bool _isSaving = false;
  bool _isSaved = false;

  String get _goalDisplay {
    switch (widget.goal) {
      case 'faang':
        return 'Crack FAANG Interviews';
      case 'master_dsa':
        return 'Master Data Structures';
      case 'competitive':
        return 'Competitive Programming';
      case 'university':
        return 'Learn for University';
      default:
        return 'Not specified';
    }
  }

  String get _skillLevelDisplay {
    switch (widget.skillLevel) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return 'Not specified';
    }
  }


  int get _weeklyHours {
    switch (widget.timeCommitment) {
      case '15-30':
        return 2; // ~22.5 mins/day * 7 = ~2.6 hours, rounded to 2
      case '30-60':
        return 5; // ~45 mins/day * 7 = ~5.25 hours, rounded to 5
      case '1-2':
        return 10; // ~1.5 hours/day * 7 = ~10.5 hours, rounded to 10
      case '2+':
        return 15; // ~2.5 hours/day * 7 = ~17.5 hours, rounded to 15
      default:
        return 5;
    }
  }

  Future<void> _saveProfile() async {
    // Get user ID using AuthHelper
    var userId = AuthHelper.getCurrentUserId();
    
    // If userId is null, try to get it directly from supabase
    if (userId == null) {
      userId = supabase.auth.currentUser?.id;
    }
    
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to save your profile'),
            backgroundColor: Colors.red,
          ),
        );
        // Redirect to login if not authenticated
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.go('/login');
          }
        });
      }
      return;
    }

    setState(() => _isSaving = true);

    final profile = ProfileEntity(
      userId: userId,
      goal: widget.goal,
      skillLevel: widget.skillLevel,
      timeCommitment: widget.timeCommitment,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _profileRepository.saveProfile(profile);

    if (mounted) {
      setState(() => _isSaving = false);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${failure.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          setState(() => _isSaved = true);
          // Navigate to home after a short delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.go('/home');
            }
          });
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Check if user is logged in first
    if (!AuthHelper.isLoggedIn()) {
      // If not logged in, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please log in to continue'),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/login');
        }
      });
      return;
    }
    
    // Auto-save when page loads, but wait a bit for auth state to be ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Small delay to ensure auth state is ready
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _saveProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(),
            const OnboardingProgress(
              currentStep: 4,
              totalSteps: 4,
              stepTitle: 'PLAN SUMMARY',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                child: Column(
                  children: [
                    // Success checkmark
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9333EA),
                        shape: BoxShape.circle,
                      ),
                      child: _isSaved
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 48,
                            )
                          : _isSaving
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 48,
                                ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'Your Personalized Learning Path is Ready!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    Text(
                      'Based on your goals and schedule, we\'ve crafted a 12-week roadmap to master Data Structures and Algorithms.',
                      style: const TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Summary card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2A2A2A),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'AI-GENERATED ROADMAP',
                                style: TextStyle(
                                  color: Color(0xFF9333EA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const Text(
                                'Valid for 2024 Prep',
                                style: TextStyle(
                                  color: Color(0xFFA0A0A0),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Target Goal
                          _SummaryItem(
                            icon: Icons.track_changes,
                            label: 'TARGET GOAL',
                            value: _goalDisplay,
                          ),
                          const SizedBox(height: 24),
                          // Experience
                          _SummaryItem(
                            icon: Icons.bar_chart,
                            label: 'EXPERIENCE',
                            value: '$_skillLevelDisplay - Trees Focus',
                          ),
                          const SizedBox(height: 24),
                          // Weekly Tempo
                          _SummaryItem(
                            icon: Icons.access_time,
                            label: 'WEEKLY TEMPO',
                            value: '$_weeklyHours hours / week',
                          ),
                          const SizedBox(height: 32),
                          const Divider(
                            color: Color(0xFF2A2A2A),
                            height: 1,
                          ),
                          const SizedBox(height: 24),
                          // 12 Weeks
                          Row(
                            children: [
                              const Text(
                                '12 Weeks',
                                style: TextStyle(
                                  color: Color(0xFFA855F7),
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'CURATED LEARNING JOURNEY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Start Learning button
                    SizedBox(
                      width: 300,
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
                          onPressed: _isSaved
                              ? () => context.go('/home')
                              : _isSaving
                                  ? null
                                  : _saveProfile,
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            _isSaved
                                ? 'Start Learning'
                                : _isSaving
                                    ? 'Saving...'
                                    : 'Start Learning',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate back to edit preferences
                        context.go('/onboarding/goal');
                      },
                      child: const Text(
                        'Edit Preferences',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Motivational quote
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '"Consistency is the key to mastery. Your first lesson on Arrays and Hashing is waiting for you."',
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
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

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF9333EA).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF9333EA),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
