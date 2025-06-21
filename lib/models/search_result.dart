import 'package:q_baca/models/books.dart';

class SearchResult {
  final String query;
  final String matchType;
  final Book? titleMatch;
  final List<Book> authorMatches;
  final List<Book> categoryMatches;

  SearchResult({
    required this.query,
    required this.matchType,
    this.titleMatch,
    required this.authorMatches,
    required this.categoryMatches,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json, String baseUrl) {
    // Fungsi helper untuk parsing daftar buku
    List<Book> parseBooks(List<dynamic>? data) {
      if (data == null) return [];
      return data.map((item) => Book.fromJson(item, baseUrl)).toList();
    }

    return SearchResult(
      query: json['query'] ?? '',
      matchType: json['match_type'] ?? 'none',
      titleMatch: json['title_match'] != null
          ? Book.fromJson(json['title_match'], baseUrl)
          : null,
      authorMatches: parseBooks(json['author_matches']),
      categoryMatches: parseBooks(json['category_matches']),
    );
  }
}
