import 'package:flutter/material.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/todays_tasks_card.dart';
import '../widgets/progress_streak_card.dart';
import '../widgets/topic_mastery_card.dart';
import '../widgets/focus_areas_card.dart';
import '../widgets/ai_mentor_insight_card.dart';

/// Dashboard content (without sidebar/header)
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Continue Learning (left) and Topic Mastery (right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const ContinueLearningCard(),
                    const SizedBox(height: 24),
                    const TodaysTasksCard(),
                    const SizedBox(height: 24),
                    const ProgressStreakCard(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right column
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const TopicMasteryCard(),
                    const SizedBox(height: 24),
                    const FocusAreasCard(),
                    const SizedBox(height: 24),
                    const AIMentorInsightCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
