import 'package:flutter/material.dart';

/// Testimonials section of landing page
class LandingTestimonials extends StatelessWidget {
  const LandingTestimonials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
      child: Column(
        children: [
          // Section header
          const Text(
            'Trusted by engineers globally.',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFFFD700),
                    size: 24,
                  )),
              const SizedBox(width: 12),
              const Text(
                '4.9/5 from 10k+ learners.',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFA0A0A0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),
          // Testimonial cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1200) {
                return Column(
                  children: const [
                    _TestimonialCard(
                      name: 'Alex Rivera',
                      role: 'Software Engineer @ Google',
                      text:
                          'The AI mentor helped me understand Dynamic Programming like never before. Landed my dream job at Google!',
                    ),
                    SizedBox(height: 24),
                    _TestimonialCard(
                      name: 'Sarah Chen',
                      role: 'Sr. SWE @ Meta',
                      text:
                          'The personalized path saved me months of grinding. I was perfectly prepared for my Meta onsite.',
                    ),
                    SizedBox(height: 24),
                    _TestimonialCard(
                      name: 'James Wilson',
                      role: 'Backend Dev @ Amazon',
                      text:
                          'Smart Revision is a game changer. I remembered every pattern during my interview. Highly recommend!',
                    ),
                  ],
                );
              }
              return Row(
                children: const [
              Expanded(
                child: _TestimonialCard(
                  name: 'Alex Rivera',
                  role: 'Software Engineer @ Google',
                  text:
                      'The AI mentor helped me understand Dynamic Programming like never before. Landed my dream job at Google!',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _TestimonialCard(
                  name: 'Sarah Chen',
                  role: 'Sr. SWE @ Meta',
                  text:
                      'The personalized path saved me months of grinding. I was perfectly prepared for my Meta onsite.',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _TestimonialCard(
                  name: 'James Wilson',
                  role: 'Backend Dev @ Amazon',
                  text:
                      'Smart Revision is a game changer. I remembered every pattern during my interview. Highly recommend!',
                ),
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

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String role;
  final String text;

  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: List.generate(
              5,
              (index) => const Icon(
                Icons.star,
                color: Color(0xFFFFD700),
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Testimonial text
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFA0A0A0),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          // Author info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF9333EA),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
