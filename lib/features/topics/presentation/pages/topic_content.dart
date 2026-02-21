import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/topic_repository.dart';
import '../widgets/time_complexity_cards.dart';

/// Topic content (without sidebar/header)
class TopicContent extends StatefulWidget {
  final String slug;

  const TopicContent({
    super.key,
    required this.slug,
  });

  @override
  State<TopicContent> createState() => _TopicContentState();
}

class _TopicContentState extends State<TopicContent> {
  final _topicRepository = di.sl<TopicRepository>();
  TopicEntity? _topic;
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedTab = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTopic();
  }

  @override
  void didUpdateWidget(TopicContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload topic if slug changed
    if (oldWidget.slug != widget.slug) {
      _loadTopic();
      // Reset tab and completion state when switching topics
      setState(() {
        _selectedTab = 0;
        _isCompleted = false;
      });
    }
  }

  Future<void> _loadTopic() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _topicRepository.getTopicBySlug(widget.slug);

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.errorMessage;
        });
      },
      (topic) {
        setState(() {
          _isLoading = false;
          _topic = topic;
        });
      },
    );
  }

  Color _getDifficultyColorValue(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  Map<String, String> _getComplexities() {
    // Default complexities for arrays
    final defaultComplexities = {
      'access': 'O(1)',
      'search': 'O(n)',
      'insertion': 'O(n)',
      'deletion': 'O(n)',
    };

    // You can parse from topic content or store in database
    return defaultComplexities;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9333EA)),
        ),
      );
    }

    if (_errorMessage != null || _topic == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Topic not found',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final topic = _topic!;
    final category = topic.category ?? 'Data Structures';
    final difficultyColor = _getDifficultyColorValue(topic.difficulty);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs
          Row(
            children: [
              TextButton(
                onPressed: () => context.go('/app/home'),
                child: const Text(
                  'Theory',
                  style: TextStyle(
                    color: Color(0xFF9333EA),
                    fontSize: 14,
                  ),
                ),
              ),
              const Text(
                ' > ',
                style: TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Color(0xFF9333EA),
                    fontSize: 14,
                  ),
                ),
              ),
              const Text(
                ' > ',
                style: TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                ),
              ),
              Text(
                topic.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Lesson metadata and title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags and read time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: difficultyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: difficultyColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            (topic.difficulty ?? 'BEGINNER').toUpperCase(),
                            style: TextStyle(
                              color: difficultyColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${topic.estimatedTimeMinutes ?? 12} min read',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      topic.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      topic.description ??
                          'A fundamental data structure concept.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Mark as Completed button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF2A2A2A),
                    width: 1,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCompleted = !_isCompleted;
                    });
                  },
                  icon: Icon(
                    _isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: _isCompleted ? Colors.green : Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Mark as Completed',
                    style: TextStyle(
                      color: _isCompleted ? Colors.green : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Tabs
          Row(
            children: [
              _TabButton(
                label: 'Overview',
                isSelected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
              const SizedBox(width: 24),
              _TabButton(
                label: 'Operations',
                isSelected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
              const SizedBox(width: 24),
              _TabButton(
                label: 'Complexity',
                isSelected: _selectedTab == 2,
                onTap: () => setState(() => _selectedTab = 2),
              ),
              const SizedBox(width: 24),
              _TabButton(
                label: 'Implementation',
                isSelected: _selectedTab == 3,
                onTap: () => setState(() => _selectedTab = 3),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Content based on selected tab
          if (_selectedTab == 0) _buildOverviewContent(topic),
          if (_selectedTab == 1) _buildOperationsContent(topic),
          if (_selectedTab == 2) _buildComplexityContent(topic),
          if (_selectedTab == 3) _buildImplementationContent(topic),
        ],
      ),
    );
  }

  Widget _buildOverviewContent(TopicEntity topic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Complexity Summary
        const Text(
          'Time Complexity Summary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TimeComplexityCards(complexities: _getComplexities()),
        const SizedBox(height: 40),
        // Conceptual Description
        const Text(
          'Conceptual Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildContentWithHighlights(topic.content),
      ],
    );
  }

  Widget _buildContentWithHighlights(String content) {
    // Simple markdown-like parsing for highlights
    final paragraphs = content.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        if (para.trim().isEmpty) return const SizedBox(height: 16);

        // Check for highlighted text (simple pattern matching)
        final highlightPattern = RegExp(r'\*\*(.*?)\*\*');
        final matches = highlightPattern.allMatches(para);

        if (matches.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              para,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.6,
              ),
            ),
          );
        }

        // Build text with highlights
        final textSpans = <TextSpan>[];
        int lastEnd = 0;

        for (final match in matches) {
          // Add text before highlight
          if (match.start > lastEnd) {
            textSpans.add(TextSpan(
              text: para.substring(lastEnd, match.start),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.6,
              ),
            ));
          }

          // Add highlighted text
          textSpans.add(TextSpan(
            text: match.group(1),
            style: const TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ));

          lastEnd = match.end;
        }

        // Add remaining text
        if (lastEnd < para.length) {
          textSpans.add(TextSpan(
            text: para.substring(lastEnd),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.6,
            ),
          ));
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RichText(
            text: TextSpan(children: textSpans),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOperationsContent(TopicEntity topic) {
    return const Center(
      child: Text(
        'Operations content coming soon...',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildComplexityContent(TopicEntity topic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimeComplexityCards(complexities: _getComplexities()),
        const SizedBox(height: 32),
        const Text(
          'Detailed Complexity Analysis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Detailed complexity analysis will be displayed here...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildImplementationContent(TopicEntity topic) {
    return const Center(
      child: Text(
        'Implementation examples coming soon...',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF9333EA)
                  : Colors.white.withOpacity(0.6),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: label.length * 8.0,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF9333EA)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
