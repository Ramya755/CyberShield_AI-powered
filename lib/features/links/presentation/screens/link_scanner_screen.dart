import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cyber_shield/core/constants/app_colors.dart';
import '../provider/scanner_provider.dart';

class LinkScannerScreen extends StatefulWidget {
  const LinkScannerScreen({super.key});

  @override
  State<LinkScannerScreen> createState() => _LinkScannerScreenState();
}

class _LinkScannerScreenState extends State<LinkScannerScreen> {
  TextEditingController linkController = TextEditingController();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ScannerProvider>(context, listen: false).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScannerProvider>(context);

    bool active = provider.result.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Link Scanner",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [
              /// MAIN CARD
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),

                  gradient: LinearGradient(
                    colors:
                        active
                            ? [
                              const Color.fromARGB(
                                255,
                                71,
                                211,
                                226,
                              ).withValues(alpha: 0.16),
                              AppColors.cardBlue,
                            ]
                            : [AppColors.card, AppColors.cardDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    /// TEXTFIELD
                    TextField(
                      controller: linkController,
                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Paste suspicious link...",
                        hintStyle: const TextStyle(color: Colors.white54),

                        prefixIcon: const Icon(
                          Icons.link,
                          color: Colors.cyanAccent,
                        ),

                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        onPressed: () async {
                          debugPrint("[UI] Button clicked");
                          debugPrint("[UI] Raw text: ${linkController.text}");

                          String link = extractLink(linkController.text);

                          debugPrint("[UI] Extracted link: $link");

                          await provider.scanLink(link);

                          debugPrint("[UI] scanLink finished");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          "Scan Link",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (provider.isLoading)
                      const CircularProgressIndicator(color: Colors.cyanAccent),

                    /// RESULT
                    if (provider.result.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color:
                              provider.result.contains("Safe")
                                  ? Colors.green.withValues(alpha: 0.18)
                                  : Colors.red.withValues(alpha: 0.18),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Text(
                          provider.result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 14),

                    /// RISK SCORE
                    if (provider.result.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Risk Score",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),

                            Text(
                              "${provider.riskScore}",
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 12),

                    /// REASONS
                    if (provider.reasons.isNotEmpty)
                      Column(
                        children:
                            provider.reasons.map((reason) {
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Text(
                                  "• $reason",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Scan History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// HISTORY
              provider.historyList.isEmpty
                  ? const Center(
                    child: Text(
                      "No History Yet",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: provider.historyList.length,

                    itemBuilder: (context, index) {
                      final item = provider.historyList[index];

                      bool safe = item["status"].toString().contains("Safe");

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),

                          gradient: LinearGradient(
                            colors:
                                safe
                                    ? [
                                      Colors.green.withValues(alpha: 0.18),
                                      AppColors.cardDark,
                                    ]
                                    : [
                                      Colors.red.withValues(alpha: 0.18),
                                      AppColors.cardDark,
                                    ],
                          ),
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),

                          leading: Icon(
                            safe ? Icons.check_circle : Icons.warning,
                            color: safe ? Colors.greenAccent : Colors.redAccent,
                          ),

                          title: Text(
                            item["url"] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Text(
                            item["status"] ?? "",
                            style: const TextStyle(color: Colors.white70),
                          ),

                          trailing: Text(
                            "${item["riskScore"]}",
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  String extractLink(String text) {
    String input = text.trim();

    if (input.isEmpty) {
      return "";
    }

    final urlPattern = r'(https?:\/\/[^\s]+)';
    final regExp = RegExp(urlPattern);

    final match = regExp.firstMatch(input);

    if (match != null) {
      return match.group(0)!;
    }

    // If user typed only domain like google.com
    if (input.contains(".") && !input.contains(" ")) {
      return input;
    }

    return "";
  }
}
