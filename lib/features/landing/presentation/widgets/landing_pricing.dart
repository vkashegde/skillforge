import 'package:flutter/material.dart';

/// Pricing section of landing page
class LandingPricing extends StatelessWidget {
  const LandingPricing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
      child: Column(
        children: [
          // Section header
          const Text(
            'Simple, transparent pricing.',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Invest in your career. Most users see a 20x ROI after their first salary bump.',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFA0A0A0),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          // Pricing cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return Column(
                  children: const [
                    _PricingCard(
                      name: 'Basic',
                      price: '\$29',
                      period: '/month',
                      features: [
                        'Curated DSA Problem Set',
                        'Basic AI Hints (50/day)',
                        'Unlimited Mock Interviews',
                        'Personalized Interview Roadmap',
                      ],
                      buttonText: 'Get Started',
                      isPopular: false,
                    ),
                    SizedBox(height: 24),
                    _PricingCard(
                      name: 'Premium',
                      price: '\$49',
                      period: '/month',
                      features: [
                        'Everything in Basic',
                        'Unlimited AI Coaching & Reviews',
                        'Unlimited AI Mock Interviews',
                        'Personalized Career Roadmap',
                      ],
                      buttonText: 'Go Premium',
                      isPopular: true,
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _PricingCard(
                    name: 'Basic',
                    price: '\$29',
                    period: '/month',
                    features: [
                      'Curated DSA Problem Set',
                      'Basic AI Hints (50/day)',
                      'Unlimited Mock Interviews',
                      'Personalized Interview Roadmap',
                    ],
                    buttonText: 'Get Started',
                    isPopular: false,
                  ),
                  SizedBox(width: 24),
                  _PricingCard(
                    name: 'Premium',
                    price: '\$49',
                    period: '/month',
                    features: [
                      'Everything in Basic',
                      'Unlimited AI Coaching & Reviews',
                      'Unlimited AI Mock Interviews',
                      'Personalized Career Roadmap',
                    ],
                    buttonText: 'Go Premium',
                    isPopular: true,
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

class _PricingCard extends StatelessWidget {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final String buttonText;
  final bool isPopular;

  const _PricingCard({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.buttonText,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isPopular
            ? const Color(0xFF1A1A1A)
            : const Color(0xFF1A1A1A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? const Color(0xFF9333EA)
              : Colors.white10,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF9333EA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (isPopular) const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  period,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFA0A0A0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF9333EA),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFA0A0A0),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular
                    ? const Color(0xFF9333EA)
                    : Colors.white,
                foregroundColor: isPopular
                    ? Colors.white
                    : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
