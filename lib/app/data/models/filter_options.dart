class FilterOptions {
  final List<int> levels;
  final List<String> categories;

  FilterOptions({
    required this.levels,
    required this.categories,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    final filters = json['filters'] as Map<String, dynamic>? ?? {};
    return FilterOptions(
      levels: List<int>.from(filters['level'] ?? []),
      categories: List<String>.from(filters['category'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filters': {
        'level': levels,
        'category': categories,
      }
    };
  }
}
