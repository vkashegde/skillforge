import 'package:flutter/material.dart';

/// Footer section of landing page
class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left - Logo and description
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DSA Mentor AI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Master Data Structures & Algorithms with personalized AI coaching. The smartest way to crack coding interviews.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA0A0A0),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Middle - Links
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _FooterColumn(
                      title: 'PLATFORM',
                      links: ['Courses', 'Roadmaps', 'Mock Interviews'],
                    ),
                    _FooterColumn(
                      title: 'RESOURCES',
                      links: ['Success Stories', 'Blog', 'Documentation'],
                    ),
                    _FooterColumn(
                      title: 'COMPANY',
                      links: ['About Us', 'Contact', 'Privacy Policy'],
                    ),
                  ],
                ),
              ),
              // Right - Social media
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Follow Us',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _SocialIcon(icon: Icons.alternate_email),
                        const SizedBox(width: 12),
                        _SocialIcon(icon: Icons.play_circle_outline),
                        const SizedBox(width: 12),
                        _SocialIcon(icon: Icons.code),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          const Text(
            '© 2024 DSA Mentor AI. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF666666),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  link,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFA0A0A0),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;

  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
