import 'package:flutter/material.dart';

/// Time complexity cards widget
class TimeComplexityCards extends StatelessWidget {
  final Map<String, String> complexities;

  const TimeComplexityCards({
    super.key,
    required this.complexities,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ComplexityCard(
        operation: 'ACCESS',
        complexity: complexities['access'] ?? 'O(1)',
        color: const Color(0xFF9333EA),
      ),
      _ComplexityCard(
        operation: 'SEARCH',
        complexity: complexities['search'] ?? 'O(n)',
        color: Colors.orange,
      ),
      _ComplexityCard(
        operation: 'INSERTION',
        complexity: complexities['insertion'] ?? 'O(n)',
        color: Colors.red,
      ),
      _ComplexityCard(
        operation: 'DELETION',
        complexity: complexities['deletion'] ?? 'O(n)',
        color: Colors.red,
      ),
    ];

    return Row(
      children: cards.map((card) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: card,
          ),
        );
      }).toList(),
    );
  }
}

class _ComplexityCard extends StatelessWidget {
  final String operation;
  final String complexity;
  final Color color;

  const _ComplexityCard({
    required this.operation,
    required this.complexity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            operation,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            complexity,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
