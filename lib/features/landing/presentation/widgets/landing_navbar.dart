import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/presentation/utils/auth_helper.dart';

/// Navigation bar for landing page
class LandingNavbar extends StatefulWidget {
  const LandingNavbar({super.key});

  @override
  State<LandingNavbar> createState() => _LandingNavbarState();
}

class _LandingNavbarState extends State<LandingNavbar> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _isLoggedIn = data.session != null;
        });
      }
    });
  }

  void _checkAuthState() {
    setState(() {
      _isLoggedIn = AuthHelper.isLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1200) {
            // Mobile/Tablet view
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DSA Mentor AI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
              ],
            );
          }
          // Desktop view
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              const Text(
                'DSA Mentor AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Navigation links
              Row(
                children: [
                  _NavLink(text: 'Features'),
                  const SizedBox(width: 32),
                  _NavLink(text: 'Success Stories'),
                  const SizedBox(width: 32),
                  _NavLink(text: 'Pricing'),
                  const SizedBox(width: 32),
                  _isLoggedIn
                      ? _NavLink(
                          text: 'Dashboard',
                          onTap: () => context.go('/home'),
                        )
                      : _NavLink(
                          text: 'Login',
                          onTap: () => context.go('/login'),
                        ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_isLoggedIn) {
                        context.go('/home');
                      } else {
                        context.go('/signup');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(_isLoggedIn ? 'Go to Dashboard' : 'Start Learning'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _NavLink({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
