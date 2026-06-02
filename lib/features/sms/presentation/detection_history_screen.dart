import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cyber_shield/core/widgets/index.dart';
import 'package:cyber_shield/features/sms/presentation/providers/scam_detection_provider.dart';

const Color kHistoryBgTop = Color(0xFF030B2D);
const Color kHistoryBgBottom = Color(0xFF060C24);
const Color kHistoryCyan = Color(0xFF42D7FF);
const Color kHistoryViolet = Color(0xFF9A63FF);
const Color kHistoryMuted = Color(0xFFAAB6D3);

class DetectionHistoryScreen extends StatefulWidget {
  const DetectionHistoryScreen({super.key});

  @override
  State<DetectionHistoryScreen> createState() => _DetectionHistoryScreenState();
}

class _DetectionHistoryScreenState extends State<DetectionHistoryScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'SMS', 'WhatsApp', 'Messenger'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHistoryBgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kHistoryBgTop, kHistoryBgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Consumer<ScamDetectionProvider>(
            builder: (context, provider, _) {
              final allMessages = provider.messages;

              final filteredMessages =
                  allMessages.where((message) {
                    if (_selectedFilter == 'All') return true;

                    final type = message.appName.toLowerCase();
                    final filterType = _selectedFilter.toLowerCase();

                    if (filterType == 'sms') {
                      return type.contains('sms') ||
                          type.contains('messaging') ||
                          type.contains('messages');
                    }

                    if (filterType == 'whatsapp') {
                      return type.contains('whatsapp');
                    }

                    if (filterType == 'messenger') {
                      return type.contains('messenger') ||
                          type.contains('facebook') ||
                          type.contains('orca') ||
                          type.contains('com.facebook.orca');
                    }

                    return true;
                  }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Threat History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${filteredMessages.length} detections found',
                          style: const TextStyle(
                            color: kHistoryMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildFilterRow(),

                  Expanded(
                    child:
                        filteredMessages.isEmpty
                            ? const Center(
                              child: EmptyStateWidget(
                                title: 'No detections found',
                                subtitle:
                                    'There are no messages matching the selected filter.',
                                icon: Icons.history_rounded,
                              ),
                            )
                            : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                100,
                              ),
                              itemCount: filteredMessages.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final detection = filteredMessages[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.18,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: DetectionCard(
                                    message: detection,
                                    onDismiss:
                                        () => provider.removeDetection(
                                          detection.id,
                                        ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      height: 54,
      margin: const EdgeInsets.only(top: 6, bottom: 4),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : kHistoryMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedFilter = filter);
              }
            },
            backgroundColor: Colors.white.withValues(alpha: 0.07),
            selectedColor: kHistoryViolet,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color:
                    isSelected
                        ? kHistoryCyan.withValues(alpha: 0.65)
                        : Colors.white.withValues(alpha: 0.10),
              ),
            ),
          );
        },
      ),
    );
  }
}
