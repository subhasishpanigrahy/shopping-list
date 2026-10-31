import 'package:flutter/material.dart';

enum ProductCategory {
  all(
    displayName: 'All Items',
    icon: Icons.auto_awesome,
    accentColor: Color(0xFF6366F1),
  ),
  fashion(
    displayName: 'Sneakers & Fashion',
    icon: Icons.checkroom_rounded,
    accentColor: Color(0xFFEC4899),
  ),
  electronics(
    displayName: 'Tech & Gadgets',
    icon: Icons.devices_rounded,
    accentColor: Color(0xFF3B82F6),
  ),
  groceries(
    displayName: 'Groceries & Quick',
    icon: Icons.local_grocery_store_rounded,
    accentColor: Color(0xFF10B981),
  ),
  beauty(
    displayName: 'Beauty & Skincare',
    icon: Icons.spa_rounded,
    accentColor: Color(0xFFF43F5E),
  ),
  home(
    displayName: 'Home & Living',
    icon: Icons.chair_rounded,
    accentColor: Color(0xFFF59E0B),
  ),
  general(
    displayName: 'General & Marketplace',
    icon: Icons.shopping_bag_rounded,
    accentColor: Color(0xFF8B5CF6),
  );

  final String displayName;
  final IconData icon;
  final Color accentColor;

  const ProductCategory({
    required this.displayName,
    required this.icon,
    required this.accentColor,
  });

  static ProductCategory fromString(String? value) {
    if (value == null) return ProductCategory.general;
    for (final cat in ProductCategory.values) {
      if (cat.name.toLowerCase() == value.toLowerCase()) {
        return cat;
      }
    }
    return ProductCategory.general;
  }
}
