import 'package:flutter/material.dart';

/// Topic Mastery section card
class TopicMasteryCard extends StatelessWidget {
  const TopicMasteryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _TopicItem(name: 'Arrays', percentage: 85, color: Colors.green),
      _TopicItem(name: 'Strings', percentage: 70, color: Colors.blue),
      _TopicItem(name: 'Linked Lists', percentage: 55, color: const Color(0xFF9333EA)),
      _TopicItem(name: 'Trees', percentage: 42, color: Colors.orange),
      _TopicItem(name: 'Graphs', percentage: 30, color: Colors.red),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Topic Mastery',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...topics.map((topic) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _TopicProgressItem(topic: topic),
              )),
        ],
      ),
    );
  }
}

class _TopicItem {
  final String name;
  final int percentage;
  final Color color;

  _TopicItem({
    required this.name,
    required this.percentage,
    required this.color,
  });
}

class _TopicProgressItem extends StatelessWidget {
  final _TopicItem topic;

  const _TopicProgressItem({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              topic.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${topic.percentage}%',
              style: TextStyle(
                color: topic.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: topic.percentage / 100,
            minHeight: 8,
            backgroundColor: const Color(0xFF2A2A2A),
            valueColor: AlwaysStoppedAnimation<Color>(topic.color),
          ),
        ),
      ],
    );
  }
}
