import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Dashboard sidebar navigation
class DashboardSidebar extends StatelessWidget {
  final String currentRoute;

  const DashboardSidebar({
    super.key,
    this.currentRoute = '/home',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          // Logo section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9333EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'DSA Mentor AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9333EA).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF9333EA),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'PREMIUM ACCESS',
                    style: TextStyle(
                      color: Color(0xFF9333EA),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF2A2A2A),
            height: 1,
          ),
          // Navigation links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _NavItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  isActive: currentRoute == '/app/home',
                  onTap: () => context.go('/app/home'),
                ),
                _NavItem(
                  icon: Icons.menu_book,
                  label: 'Theory',
                  isActive: currentRoute.startsWith('/app/theory'),
                  onTap: () => context.go('/app/theory/arrays'),
                ),
                _NavItem(
                  icon: Icons.code,
                  label: 'Practice Lab',
                  isActive: currentRoute.startsWith('/app/practice'),
                  onTap: () => context.go('/app/practice'),
                ),
                _NavItem(
                  icon: Icons.refresh,
                  label: 'Smart Revision',
                  onTap: () {},
                ),
                _NavItem(
                  icon: Icons.psychology,
                  label: 'AI Mentor',
                  onTap: () {},
                ),
                _NavItem(
                  icon: Icons.people,
                  label: 'Community',
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Settings
          const Divider(
            color: Color(0xFF2A2A2A),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _NavItem(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF9333EA).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(
                  color: const Color(0xFF9333EA),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF9333EA)
                  : const Color(0xFFA0A0A0),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF9333EA)
                    : const Color(0xFFA0A0A0),
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
