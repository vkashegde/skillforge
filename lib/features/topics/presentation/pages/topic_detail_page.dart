import 'package:flutter/material.dart';
import '../../../home/presentation/widgets/app_layout.dart';
import 'topic_content.dart';

/// Topic detail page showing theory content
class TopicDetailPage extends StatelessWidget {
  final String slug;

  const TopicDetailPage({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/app/theory/$slug',
      child: TopicContent(slug: slug),
    );
  }
}
