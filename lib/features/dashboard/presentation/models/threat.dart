class Threat {
  final String title;
  final String description;
  final bool isDangerous;
  final double riskScore;
  final String url;

  Threat({
    required this.title,
    required this.description,
    required this.isDangerous,
    required this.riskScore,
    required this.url,
  });

  factory Threat.fromJson(Map<String, dynamic> json) {
    return Threat(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isDangerous: json['isDangerous'] ?? false,
      riskScore: (json['riskScore'] ?? 0).toDouble(),
      url: json['url'] ?? '',
    );
  }
}