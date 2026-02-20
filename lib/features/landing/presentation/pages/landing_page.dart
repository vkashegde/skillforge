import 'package:flutter/material.dart';
import '../widgets/landing_navbar.dart';
import '../widgets/landing_hero.dart';
import '../widgets/landing_features.dart';
import '../widgets/landing_testimonials.dart';
import '../widgets/landing_pricing.dart';
import '../widgets/landing_cta.dart';
import '../widgets/landing_footer.dart';

/// Landing page for the DSA learning platform
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LandingNavbar(),
            const LandingHero(),
            const LandingFeatures(),
            const LandingTestimonials(),
            const LandingPricing(),
            const LandingCTA(),
            const LandingFooter(),
          ],
        ),
      ),
    );
  }
}
