import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation buttons for onboarding pages
class OnboardingNavigation extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final bool canGoBack;
  final bool canSkip;
  final String? continueText;

  const OnboardingNavigation({
    super.key,
    this.onBack,
    this.onContinue,
    this.onSkip,
    this.canGoBack = true,
    this.canSkip = false,
    this.continueText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (canGoBack)
            TextButton.icon(
              onPressed: onBack ?? () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          // Skip button (center)
          if (canSkip)
            TextButton(
              onPressed: onSkip,
              child: const Text(
                'Skip for now',
                style: TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          // Continue button
          Container(
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
              onPressed: onContinue,
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                continueText ?? 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
