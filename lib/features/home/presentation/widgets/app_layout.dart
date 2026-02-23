import 'package:flutter/material.dart';
import 'app_sidebar.dart';
import 'dashboard_header.dart';

/// Main app layout with persistent sidebar
class AppLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AppLayout({super.key, required this.child, required this.currentRoute});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _isSidebarCollapsed = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Row(
        children: [
          // Unified sidebar - persistent across routes
          AppSidebar(
            currentRoute: widget.currentRoute,
            isCollapsed: _isSidebarCollapsed,
            onToggle: _toggleSidebar,
          ),
          // Main content area
          Expanded(
            child: Column(
              children: [
                // Header
                const DashboardHeader(),
                // Content - changes based on route
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
