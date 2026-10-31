import 'package:flutter/material.dart';
import 'product_category.dart';

/// ============================================================================
/// FILE: store_info.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Bridges abstract user shopping queries with physical shopping destinations
/// (native apps & external web storefronts). Encapsulates metadata, URL
/// generation, brand styling, and serialization so users can add custom stores.
///
/// WHAT IT DOES:
/// 1. Holds store branding (name, logo, colors, badges, tagline).
/// 2. Defines deep link schemas and Android package IDs.
/// 3. Defines search URL templates containing `{query}` placeholders.
/// 4. Supports JSON serialization/deserialization for user-created custom stores.
/// 5. Flags built-in vs user-added stores via [isCustom].
///
/// HOW IT DOES:
/// [buildWebSearchUrl] and [buildDeepLink] escape query parameters with
/// [Uri.encodeComponent] and substitute them into the `{query}` token.
/// ============================================================================
class StoreInfo {
  final String id;
  final String name;
  final ProductCategory category;
  final String webSearchUrlTemplate;
  final String? deepLinkScheme;
  final String? packageName;
  final String logoUrl;
  final Color brandColor;
  final bool isVerifiedOfficial;
  final List<String> associatedBrands;
  final String badgeText;
  final String tagline;
  final bool isCustom;

  const StoreInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.webSearchUrlTemplate,
    this.deepLinkScheme,
    this.packageName,
    required this.logoUrl,
    required this.brandColor,
    this.isVerifiedOfficial = false,
    this.associatedBrands = const [],
    required this.badgeText,
    required this.tagline,
    this.isCustom = false,
  });

  /// Constructs a valid web search URL by safely URL-encoding the search query.
  String buildWebSearchUrl(String query) {
    final encoded = Uri.encodeComponent(query.trim());
    return webSearchUrlTemplate.replaceAll('{query}', encoded);
  }

  /// Constructs a native app deep link URI by safely URL-encoding the search query.
  String? buildDeepLink(String query) {
    if (deepLinkScheme == null) return null;
    final encoded = Uri.encodeComponent(query.trim());
    return deepLinkScheme!.replaceAll('{query}', encoded);
  }

  /// Serializes instance to a JSON map for persistent local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'webSearchUrlTemplate': webSearchUrlTemplate,
      'deepLinkScheme': deepLinkScheme,
      'packageName': packageName,
      'logoUrl': logoUrl,
      'brandColor': brandColor.toARGB32(),
      'isVerifiedOfficial': isVerifiedOfficial,
      'associatedBrands': associatedBrands,
      'badgeText': badgeText,
      'tagline': tagline,
      'isCustom': isCustom,
    };
  }

  /// Deserializes a JSON map into a typed [StoreInfo] instance.
  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      category: ProductCategory.fromString(json['category'] as String?),
      webSearchUrlTemplate: json['webSearchUrlTemplate'] as String,
      deepLinkScheme: json['deepLinkScheme'] as String?,
      packageName: json['packageName'] as String?,
      logoUrl: json['logoUrl'] as String? ?? '',
      brandColor: Color((json['brandColor'] as num?)?.toInt() ?? 0xFF6366F1),
      isVerifiedOfficial: json['isVerifiedOfficial'] as bool? ?? false,
      associatedBrands: (json['associatedBrands'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      badgeText: json['badgeText'] as String? ?? '⭐ Custom Store',
      tagline: json['tagline'] as String? ?? 'User-added shopping destination',
      isCustom: json['isCustom'] as bool? ?? true,
    );
  }
}
