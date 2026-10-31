import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/product_category.dart';
import '../models/shopping_item.dart';
import '../models/store_info.dart';
import '../services/category_detector.dart';

/// ============================================================================
/// FILE: shopping_provider.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Centralizes all shopping list state management and persistence in accordance
/// with the Provider / Observable pattern. Manages shopping items and user-added
/// custom stores so they persist locally and update UI reactively.
///
/// WHAT IT DOES:
/// 1. Holds the in-memory list of [ShoppingItem]s and [StoreInfo] custom stores.
/// 2. Manages UI filter states: [selectedCategoryFilter] and [searchQuery].
/// 3. Computes dynamic derived states: [filteredItems], [totalCount],
///    [activeCount], and [completedCount].
/// 4. Provides asynchronous CRUD operations for items and custom stores:
///    - [addItem] (with automatic categorization and brand inference).
///    - [toggleItem] (completion strike-through toggle).
///    - [updateItem] (editing notes or properties).
///    - [removeItem] (single item deletion with undo capability).
///    - [clearCompleted] and [clearAll].
///    - [addCustomStore] & [removeCustomStore].
/// 5. Automatically synchronizes mutations to local persistent storage (`shared_preferences`).
/// ============================================================================
class ShoppingProvider extends ChangeNotifier {
  static const String _storageKey = 'smart_shopping_list_items_v1';
  static const String _customStoresStorageKey = 'smart_shopping_custom_stores_v1';
  static const _uuid = Uuid();

  List<ShoppingItem> _items = [];
  List<StoreInfo> _customStores = [];
  ProductCategory _selectedCategoryFilter = ProductCategory.all;
  String _searchQuery = '';
  bool _isLoading = true;

  ShoppingProvider() {
    loadItems();
  }

  // --- GETTERS ---

  /// Unmodifiable view of all shopping items in memory.
  List<ShoppingItem> get items => List.unmodifiable(_items);

  /// Unmodifiable view of all user-added custom stores.
  List<StoreInfo> get customStores => List.unmodifiable(_customStores);

  /// The currently active category filter tab.
  ProductCategory get selectedCategoryFilter => _selectedCategoryFilter;

  /// The active text search query applied to the list.
  String get searchQuery => _searchQuery;

  /// Whether items are currently being loaded from disk.
  bool get isLoading => _isLoading;

  /// Total count of items regardless of completion state.
  int get totalCount => _items.length;

  /// Count of items pending purchase.
  int get activeCount => _items.where((i) => !i.isChecked).length;

  /// Count of items marked as completed.
  int get completedCount => _items.where((i) => i.isChecked).length;

  /// Filtered subset of items matching both the category chip and search query.
  List<ShoppingItem> get filteredItems {
    return _items.where((item) {
      // 1. Evaluate Category Filter
      if (_selectedCategoryFilter != ProductCategory.all &&
          item.category != _selectedCategoryFilter) {
        return false;
      }
      // 2. Evaluate Text Search Filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesBrand = item.brand?.toLowerCase().contains(query) ?? false;
        final matchesCategory = item.category.displayName.toLowerCase().contains(query);
        return matchesTitle || matchesBrand || matchesCategory;
      }
      return true;
    }).toList();
  }

  // --- FILTER CONTROLS ---

  /// Updates active category filter and notifies UI listeners.
  void setCategoryFilter(ProductCategory category) {
    if (_selectedCategoryFilter != category) {
      _selectedCategoryFilter = category;
      notifyListeners();
    }
  }

  /// Updates active search query and notifies UI listeners.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // --- DISK STORAGE & SEEDING ---

  /// Loads persisted items and custom stores from SharedPreferences.
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Load custom stores
      await _loadCustomStoresFromPrefs(prefs);

      // 2. Load shopping items
      final String? jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        _items = decoded
            .map((item) => ShoppingItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        // Seed default items showcasing the app's aggregator capabilities
        _seedDefaultItems();
        await _saveToDisk();
      }
    } catch (e) {
      debugPrint('Error loading shopping list: $e');
      if (_items.isEmpty) {
        _seedDefaultItems();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCustomStoresFromPrefs(SharedPreferences prefs) async {
    try {
      final String? customJson = prefs.getString(_customStoresStorageKey);
      if (customJson != null && customJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(customJson) as List<dynamic>;
        _customStores = decoded
            .map((s) => StoreInfo.fromJson(s as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading custom stores: $e');
      _customStores = [];
    }
  }

  /// Populates the list with introductory items across major retail categories.
  void _seedDefaultItems() {
    _items = [
      ShoppingItem(
        id: _uuid.v4(),
        title: 'Nike Air Max 270',
        category: ProductCategory.fashion,
        brand: 'Nike',
        isChecked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        quantity: 1,
      ),
      ShoppingItem(
        id: _uuid.v4(),
        title: 'MacBook Air M3',
        category: ProductCategory.electronics,
        brand: 'Apple',
        isChecked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        quantity: 1,
      ),
      ShoppingItem(
        id: _uuid.v4(),
        title: 'Almond Butter',
        category: ProductCategory.groceries,
        isChecked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        quantity: 2,
      ),
      ShoppingItem(
        id: _uuid.v4(),
        title: 'CeraVe Hydrating Cleanser',
        category: ProductCategory.beauty,
        brand: 'CeraVe',
        isChecked: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        quantity: 1,
      ),
    ];
  }

  /// Serializes and writes current item state to SharedPreferences.
  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listJson = _items.map((i) => i.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(listJson));
    } catch (e) {
      debugPrint('Error saving shopping list: $e');
    }
  }

  /// Serializes and writes user-added custom stores to SharedPreferences.
  Future<void> _saveCustomStoresToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listJson = _customStores.map((s) => s.toJson()).toList();
      await prefs.setString(_customStoresStorageKey, jsonEncode(listJson));
    } catch (e) {
      debugPrint('Error saving custom stores: $e');
    }
  }

  // --- CRUD MUTATIONS FOR ITEMS ---

  /// Adds a new item. If [customCategory] or [customBrand] are omitted,
  /// the system runs the [CategoryDetector] engine to auto-infer them.
  Future<void> addItem(
    String rawTitle, {
    ProductCategory? customCategory,
    String? customBrand,
    String? notes,
    int quantity = 1,
  }) async {
    final title = rawTitle.trim();
    if (title.isEmpty) return;

    // Detect category and brand if not explicitly provided by user
    final detection = CategoryDetector.detect(title);
    final category = customCategory ?? detection.category;
    final brand = customBrand ?? detection.brand;

    final newItem = ShoppingItem(
      id: _uuid.v4(),
      title: title,
      category: category,
      brand: brand,
      isChecked: false,
      createdAt: DateTime.now(),
      quantity: quantity,
      notes: notes,
    );

    // Prepend to top of list for immediate user visibility
    _items.insert(0, newItem);
    notifyListeners();
    await _saveToDisk();
  }

  /// Toggles the completion checkbox status of an item.
  Future<void> toggleItem(String id) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      final current = _items[index];
      _items[index] = current.copyWith(isChecked: !current.isChecked);
      notifyListeners();
      await _saveToDisk();
    }
  }

  /// Replaces an existing item with an updated snapshot.
  Future<void> updateItem(ShoppingItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
      await _saveToDisk();
    }
  }

  /// Deletes an item by unique identifier.
  Future<void> removeItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
    await _saveToDisk();
  }

  /// Removes all items whose [isChecked] property is true.
  Future<void> clearCompleted() async {
    _items.removeWhere((i) => i.isChecked);
    notifyListeners();
    await _saveToDisk();
  }

  /// Wipes all items from the list.
  Future<void> clearAll() async {
    _items.clear();
    notifyListeners();
    await _saveToDisk();
  }

  // --- CRUD MUTATIONS FOR CUSTOM STORES ---

  /// Adds a new user-defined custom store or website.
  Future<void> addCustomStore(StoreInfo store) async {
    _customStores.removeWhere((s) => s.id == store.id);
    _customStores.insert(0, store);
    notifyListeners();
    await _saveCustomStoresToDisk();
  }

  /// Removes a custom store by ID.
  Future<void> removeCustomStore(String storeId) async {
    _customStores.removeWhere((s) => s.id == storeId);
    notifyListeners();
    await _saveCustomStoresToDisk();
  }
}
