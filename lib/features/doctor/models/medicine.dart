class Medicine {
  final String remedy;
  final String commonName;
  final String general;
  final String url;
  final Map<String, dynamic> sections;

  Medicine({
    required this.remedy,
    required this.commonName,
    required this.general,
    required this.url,
    required this.sections,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    final sections = json['sections'] ?? {};

    return Medicine(
      remedy: sections['Remedy'] ?? '',
      commonName: sections['Common Name'] ?? '',
      general: sections['General'] ?? '',
      url: json['url'] ?? '',
      sections: sections, // keep everything else for details page
    );
  }
}