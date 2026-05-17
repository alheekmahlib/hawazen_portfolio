import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../domain/portfolio_models.dart';

const _contentUrlKey = 'content.url';
const _contentCacheKey = 'content.cache';
const _contentCacheUrlKey = 'content.cache.url';

class ContentRepository {
  Future<String?> getContentUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_contentUrlKey) ??
        (AppConfig.defaultContentUrl.isEmpty
            ? null
            : AppConfig.defaultContentUrl);
  }

  Future<void> setContentUrl(String? url) async {
    final prefs = await SharedPreferences.getInstance();
    if (url == null || url.trim().isEmpty) {
      await prefs.remove(_contentUrlKey);
      await prefs.remove(_contentCacheKey);
      await prefs.remove(_contentCacheUrlKey);
      return;
    }
    await prefs.setString(_contentUrlKey, url.trim());
    await prefs.remove(_contentCacheKey);
    await prefs.remove(_contentCacheUrlKey);
  }

  Future<PortfolioContent> load({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final url = await getContentUrl();
    final cacheUrl = prefs.getString(_contentCacheUrlKey) ?? '';

    if (url == null || url.isEmpty) {
      throw StateError('Content URL not set');
    }

    if (!forceRefresh) {
      final cached = prefs.getString(_contentCacheKey);
      if (cached != null && cacheUrl == url) {
        final decoded = jsonDecode(cached);
        if (decoded is Map<String, Object?>) {
          return PortfolioContent.fromJson(decoded);
        }
      }
    }

    try {
      final content = await _fetchContent(url);
      await _cacheContent(content, url, prefs);
      return content;
    } catch (_) {
      // Try fallback URL (GitLab) when primary (GitHub) is unreachable.
      final fallback = AppConfig.fallbackContentUrl;
      if (fallback.isNotEmpty && url != fallback) {
        try {
          final content = await _fetchContent(fallback);
          await _cacheContent(content, fallback, prefs);
          return content;
        } catch (e2) {
          throw StateError('Failed to load content from both GitHub and GitLab: ${e2.toString()}');
        }
      }
      rethrow;
    }
  }

  Future<void> saveDraftToCache(PortfolioContent content) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = const JsonEncoder.withIndent(
      '  ',
    ).convert(content.toJson());
    await prefs.setString(_contentCacheKey, encoded);
    final url = await getContentUrl();
    await prefs.setString(_contentCacheUrlKey, url ?? '');
  }

  Future<PortfolioContent> _fetchContent(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, Object?>) {
        return PortfolioContent.fromJson(decoded);
      }
    }
    throw StateError('Failed to load content: HTTP ${response.statusCode}');
  }

  Future<void> _cacheContent(
    PortfolioContent content,
    String url,
    SharedPreferences prefs,
  ) async {
    final encoded = const JsonEncoder.withIndent('  ').convert(content.toJson());
    await prefs.setString(_contentCacheKey, encoded);
    await prefs.setString(_contentCacheUrlKey, url);
  }
}
