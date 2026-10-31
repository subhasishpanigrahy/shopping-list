import 'package:flutter/foundation.dart';

import 'product_category.dart';

@immutable
class ShoppingItem {
  final String id;
  final String title;
  final ProductCategory category;
  final String? brand;
  final bool isChecked;
  final DateTime createdAt;
  final int quantity;
  final String? notes;

  const ShoppingItem({
    required this.id,
    required this.title,
    required this.category,
    this.brand,
    this.isChecked = false,
    required this.createdAt,
    this.quantity = 1,
    this.notes,
  });

  ShoppingItem copyWith({
    String? id,
    String? title,
    ProductCategory? category,
    String? brand,
    bool? isChecked,
    DateTime? createdAt,
    int? quantity,
    String? notes,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt ?? this.createdAt,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'brand': brand,
      'isChecked': isChecked,
      'createdAt': createdAt.toIso8601String(),
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      title: json['title'] as String,
      category: ProductCategory.fromString(json['category'] as String?),
      brand: json['brand'] as String?,
      isChecked: json['isChecked'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          category == other.category &&
          brand == other.brand &&
          isChecked == other.isChecked &&
          createdAt == other.createdAt &&
          quantity == other.quantity &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      category.hashCode ^
      brand.hashCode ^
      isChecked.hashCode ^
      createdAt.hashCode ^
      quantity.hashCode ^
      notes.hashCode;
}
