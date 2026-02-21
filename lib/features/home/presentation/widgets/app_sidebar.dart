import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Unified sidebar navigation for the entire app
class AppSidebar extends StatefulWidget {
  final String currentRoute;

  const AppSidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isTheoryExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand Theory section if on theory route
    _isTheoryExpanded = widget.currentRoute.startsWith('/app/theory');
  }

  @override
  void didUpdateWidget(AppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update expansion state when route changes
    if (widget.currentRoute != oldWidget.currentRoute) {
      setState(() {
        _isTheoryExpanded = widget.currentRoute.startsWith('/app/theory');
      });
    }
  }

  String? _getTopicSlugFromRoute() {
    if (widget.currentRoute.startsWith('/app/theory/')) {
      return widget.currentRoute.split('/').last;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTopicSlug = _getTopicSlugFromRoute();
    final isTheoryRoute = widget.currentRoute.startsWith('/app/theory');

    return Container(
      width: 280,
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
                    const Expanded(
                      child: Text(
                        'DSA Mentor AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                  isActive: widget.currentRoute == '/app/home',
                  onTap: () => context.go('/app/home'),
                ),
                _NavItem(
                  icon: Icons.menu_book,
                  label: 'Theory',
                  isActive: isTheoryRoute,
                  isExpandable: true,
                  isExpanded: _isTheoryExpanded,
                  onTap: () {
                    setState(() {
                      _isTheoryExpanded = !_isTheoryExpanded;
                    });
                  },
                  children: _isTheoryExpanded
                      ? [
                          _SectionHeader(label: 'DATA STRUCTURES'),
                          _SubNavItem(
                            label: 'Arrays',
                            slug: 'arrays',
                            isSelected: selectedTopicSlug == 'arrays',
                            onTap: () => context.go('/app/theory/arrays'),
                          ),
                          _SubNavItem(
                            label: 'Strings',
                            slug: 'strings',
                            isSelected: selectedTopicSlug == 'strings',
                            onTap: () => context.go('/app/theory/strings'),
                          ),
                          _SubNavItem(
                            label: 'Linked Lists',
                            slug: 'linked-lists',
                            isSelected: selectedTopicSlug == 'linked-lists',
                            onTap: () => context.go('/app/theory/linked-lists'),
                          ),
                          _SubNavItem(
                            label: 'Stacks',
                            slug: 'stacks',
                            isSelected: selectedTopicSlug == 'stacks',
                            onTap: () => context.go('/app/theory/stacks'),
                          ),
                          _SubNavItem(
                            label: 'Queues',
                            slug: 'queues',
                            isSelected: selectedTopicSlug == 'queues',
                            onTap: () => context.go('/app/theory/queues'),
                          ),
                          _SubNavItem(
                            label: 'Trees',
                            slug: 'trees',
                            isSelected: selectedTopicSlug == 'trees',
                            onTap: () => context.go('/app/theory/trees'),
                          ),
                          _SubNavItem(
                            label: 'Graphs',
                            slug: 'graphs',
                            isSelected: selectedTopicSlug == 'graphs',
                            onTap: () => context.go('/app/theory/graphs'),
                          ),
                          const SizedBox(height: 16),
                          _SectionHeader(label: 'ALGORITHMS'),
                          _SubNavItem(
                            label: 'Sorting',
                            slug: 'sorting',
                            isSelected: selectedTopicSlug == 'sorting',
                            onTap: () => context.go('/app/theory/sorting'),
                          ),
                          _SubNavItem(
                            label: 'Searching',
                            slug: 'searching',
                            isSelected: selectedTopicSlug == 'searching',
                            onTap: () => context.go('/app/theory/searching'),
                          ),
                          _SubNavItem(
                            label: 'Recursion',
                            slug: 'recursion',
                            isSelected: selectedTopicSlug == 'recursion',
                            onTap: () => context.go('/app/theory/recursion'),
                          ),
                          _SubNavItem(
                            label: 'Dynamic Programming',
                            slug: 'dynamic-programming',
                            isSelected: selectedTopicSlug == 'dynamic-programming',
                            onTap: () => context.go('/app/theory/dynamic-programming'),
                          ),
                        ]
                      : null,
                ),
                _NavItem(
                  icon: Icons.code,
                  label: 'Practice Lab',
                  onTap: () {},
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
  final bool isExpandable;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<Widget>? children;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isExpandable = false,
    this.isExpanded = false,
    required this.onTap,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
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
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF9333EA)
                          : const Color(0xFFA0A0A0),
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isExpandable)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isActive
                        ? const Color(0xFF9333EA)
                        : const Color(0xFFA0A0A0),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        if (isExpanded && children != null) ...children!,
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, top: 16, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SubNavItem extends StatelessWidget {
  final String label;
  final String slug;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubNavItem({
    required this.label,
    required this.slug,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 48, right: 12, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF9333EA).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF9333EA),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF9333EA)
                      : const Color(0xFFA0A0A0),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF9333EA),
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
}
