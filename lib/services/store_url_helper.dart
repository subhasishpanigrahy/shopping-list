/// ============================================================================
/// FILE: store_url_helper.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Most users don't know technical URL query patterns (like `?q={query}`).
/// To make adding custom stores completely frictionless (Idea 1 + Idea 2),
/// this service parses arbitrary input (domains, homepages, or search URLs),
/// sanitizes them, generates standardized `{query}` search templates, and
/// fetches high-resolution site favicons automatically.
///
/// WHAT IT DOES:
/// 1. Extracts a clean, normalized domain from any URL string.
/// 2. Auto-constructs a working search URL template containing `{query}`.
/// 3. Detects if the user pasted an existing search URL and replaces the query term.
/// 4. Generates an icon/logo URL using the global unavatar service.
/// 5. Suggests a capitalized store title from the domain if name is empty.
///
/// HOW IT DOES:
/// Uses Dart's [Uri] parser and regular expressions to strip protocols, www
/// subdomains, and trailing slashes, mapping common query parameter names
/// (`q`, `k`, `query`, `search`, `text`, `keyword`) to `{query}`.
/// ============================================================================
class StoreUrlHelper {
  /// Extracts the base domain from any URL or raw domain string.
  /// Examples:
  /// - `https://www.decathlon.in/products` -> `decathlon.in`
  /// - `vegnonveg.com` -> `vegnonveg.com`
  /// - `http://store.nike.com/in/` -> `store.nike.com`
  static String extractDomain(String input) {
    String trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) return '';

    // Prepend protocol if missing so Uri.parse can parse host correctly
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      trimmed = 'https://$trimmed';
    }

    try {
      final uri = Uri.parse(trimmed);
      String host = uri.host;
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }
      return host.isNotEmpty ? host : trimmed.replaceAll(RegExp(r'https?://'), '');
    } catch (_) {
      // Fallback regex strip
      return trimmed
          .replaceAll(RegExp(r'^https?://'), '')
          .replaceAll(RegExp(r'^www\.'), '')
          .split('/')
          .first;
    }
  }

  /// Automatically builds a parameterized search URL from any input URL.
  /// Handles 3 scenarios:
  /// 1. Already contains `{query}`: returns as-is (with https://).
  /// 2. User pasted a search result URL (e.g. `https://site.com/search?q=shoes`):
  ///    replaces the search keyword value with `{query}`.
  /// 3. User pasted a homepage or plain domain (e.g. `decathlon.in`):
  ///    auto-appends standard search path `https://{domain}/search?q={query}`.
  static String buildSearchUrlTemplate(String rawInput) {
    String input = rawInput.trim();
    if (input.isEmpty) return '';

    // Ensure valid scheme
    if (!input.startsWith('http://') && !input.startsWith('https://')) {
      input = 'https://$input';
    }

    // 1. If user already included the {query} placeholder, honor it
    if (input.contains('{query}')) {
      return input;
    }

    try {
      final uri = Uri.parse(input);

      // 2. Check if the URL has query parameters with common search keys
      final searchKeys = ['q', 'k', 'query', 'keyword', 'search', 'text', 'searchTerm'];
      for (final key in searchKeys) {
        if (uri.queryParameters.containsKey(key)) {
          final newParams = Map<String, String>.from(uri.queryParameters);
          newParams[key] = '{query}';
          final newUri = uri.replace(queryParameters: newParams);
          // Uri.replace encodes {query} as %7Bquery%7D, so decode it back
          return newUri.toString().replaceAll('%7Bquery%7D', '{query}');
        }
      }

      // If there are other parameters, append &q={query}
      if (uri.hasQuery) {
        return '$input&q={query}';
      }

      // 3. Fallback for root domain / homepage: append standard /search?q={query}
      final cleanBase = input.endsWith('/') ? input.substring(0, input.length - 1) : input;
      return '$cleanBase/search?q={query}';
    } catch (_) {
      final clean = input.endsWith('/') ? input.substring(0, input.length - 1) : input;
      return '$clean/search?q={query}';
    }
  }

  /// Generates a favicon/brand logo URL via unavatar.io
  static String buildLogoUrl(String domain) {
    final clean = extractDomain(domain);
    if (clean.isEmpty) return '';
    return 'https://unavatar.io/$clean';
  }

  /// Suggests a store name derived from the domain (e.g. `vegnonveg.com` -> `Vegnonveg`)
  static String suggestStoreName(String input) {
    final domain = extractDomain(input);
    if (domain.isEmpty) return '';
    final parts = domain.split('.');
    if (parts.isEmpty) return domain;
    final name = parts.first;
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}
