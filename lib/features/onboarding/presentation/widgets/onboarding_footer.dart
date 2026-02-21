import 'package:flutter/material.dart';

/// Footer widget for onboarding pages
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Privacy and Terms
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          // Right side - Copyright
          const Text(
            '© 2024 DSA Mentor AI. Built for future engineers.',
            style: TextStyle(
              color: Color(0xFFA0A0A0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
