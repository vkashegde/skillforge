import 'package:flutter/material.dart';

/// Features section of landing page
class LandingFeatures extends StatelessWidget {
  const LandingFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
      child: Column(
        children: [
          // Section header
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: 'Everything you need to '),
                TextSpan(
                  text: 'excel',
                  style: TextStyle(color: Color(0xFF9333EA)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Our AI-driven platform adapts to your pace and identifies your weak spots automatically, ensuring every minute of practice counts.',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFA0A0A0),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          // Feature cards grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;
              if (constraints.maxWidth < 900) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth < 1200) {
                crossAxisCount = 2;
              }
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.1,
                children: const [
              _FeatureCard(
                icon: Icons.timeline,
                title: 'Personalized Path',
                description:
                    'Tailored roadmaps based on your target companies, experience level, and timeline for the big day.',
              ),
              _FeatureCard(
                icon: Icons.smart_toy,
                title: 'AI Mentor',
                description:
                    '24/7 real-time code reviews, intelligent hints, and deep conceptual explanations without giving away the answer.',
              ),
              _FeatureCard(
                icon: Icons.refresh,
                title: 'Smart Revision',
                description:
                    'Spaced repetition algorithms help you master complex patterns and ensure you never forget a pattern once you\'ve learned it.',
              ),
              _FeatureCard(
                icon: Icons.bar_chart,
                title: 'Progress Tracking',
                description:
                    'Detailed analytics on your problem-solving speed, accuracy, and mastery level across different categories.',
              ),
              _FeatureCard(
                icon: Icons.videocam,
                title: 'Mock Interviews',
                description:
                    'Realistic coding interview simulations with instant AI feedback on both your code and your verbal communication.',
              ),
              _FeatureCard(
                icon: Icons.people,
                title: 'Community Hub',
                description:
                    'Discuss problems with a community of ambitious developers and learn from shared Interview experiences.',
              ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF9333EA),
              size: 24,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFA0A0A0),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
