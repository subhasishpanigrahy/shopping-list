import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/store_catalog.dart';
import '../models/product_category.dart';
import '../providers/shopping_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_custom_store_sheet.dart';
import '../widgets/add_item_bar.dart';
import '../widgets/affiliate_disclosure_dialog.dart';
import '../widgets/shopping_item_tile.dart';

/// ============================================================================
/// FILE: home_screen.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Serves as the primary viewport and application orchestrator. Coordinates the
/// interaction between the shopping checklist, ambient categorization feedback,
/// metric status indicators, and modal store browsing.
///
/// WHAT IT DOES:
/// 1. Presents a top AppBar with branding and quick-action menu (Catalog Directory,
///    Clear Completed, Clear All).
/// 2. Displays live metrics (Pending items, Completed items, Total Stores indexed).
/// 3. Houses horizontal category filter chips allowing instant filtering.
/// 4. Renders the scrollable list of [ShoppingItemTile] widgets or an empty state.
/// 5. Docks the [AddItemBar] at the bottom with keyboard inset handling.
/// 6. Allows managing built-in and user-added custom stores.
/// ============================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Displays the directory dialog indexing all 28+ supported stores and their features
  void _showCatalogDialog(BuildContext context) {
    final provider = context.read<ShoppingProvider>();
    final customStores = provider.customStores;
    final theme = AppTheme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.borderSubtle),
        ),
        title: Row(
          children: [
            const Icon(Icons.hub_rounded, color: AppTheme.accentEmerald),
            const SizedBox(width: 10),
            Text(
              'Universal Store Catalog',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'External websites are first-class citizens. Smart List compares prices across top official brand stores, quick commerce & user-added websites:',
                style: TextStyle(color: theme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Custom Stores Section
                    if (customStores.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 6),
                        child: Text(
                          '⭐ MY CUSTOM STORES',
                          style: TextStyle(
                            color: AppTheme.accentAmber,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ...customStores.map((store) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: store.brandColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    store.name,
                                    style: TextStyle(
                                      color: theme.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 16, color: AppTheme.accentRose),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    provider.removeCustomStore(store.id);
                                    Navigator.pop(ctx);
                                  },
                                ),
                              ],
                            ),
                          )),
                      Divider(color: theme.borderSubtle, height: 16),
                    ],

                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 6),
                      child: Text(
                        'INDEXED GLOBAL STORES',
                        style: TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...StoreCatalog.allStores.map((store) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: store.brandColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                store.name,
                                style: TextStyle(
                                  color: theme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              store.badgeText,
                              style: TextStyle(
                                color: theme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add_rounded, size: 16, color: AppTheme.accentCyan),
            onPressed: () {
              Navigator.pop(ctx);
              AddCustomStoreSheet.show(context);
            },
            label: const Text(
              '+ Add Store',
              style: TextStyle(
                color: AppTheme.accentCyan,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Got It',
              style: TextStyle(
                color: AppTheme.accentEmerald,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: theme.bg,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.accentEmerald, AppTheme.accentCyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Shopping List',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: theme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Universal Store & Web Aggregator',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.accentCyan,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (ctx, tp, _) => IconButton(
              tooltip: tp.isDarkMode ? 'Switch to Light Theme' : 'Switch to Dark Theme',
              icon: Icon(
                tp.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: tp.isDarkMode ? AppTheme.accentAmber : AppTheme.accentIndigo,
              ),
              onPressed: () => tp.toggleTheme(),
            ),
          ),
          IconButton(
            tooltip: 'Add Custom Store',
            icon: const Icon(Icons.add_business_rounded, color: AppTheme.accentCyan),
            onPressed: () => AddCustomStoreSheet.show(context),
          ),
          IconButton(
            tooltip: 'Store Catalog Directory',
            icon: const Icon(Icons.travel_explore_rounded, color: AppTheme.accentEmerald),
            onPressed: () => _showCatalogDialog(context),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: theme.textSecondary),
            color: theme.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.borderSubtle),
            ),
            onSelected: (val) {
              if (val == 'clear_completed') {
                provider.clearCompleted();
              } else if (val == 'clear_all') {
                _confirmClearAll(context, provider);
              } else if (val == 'add_store') {
                AddCustomStoreSheet.show(context);
              } else if (val == 'about') {
                _showCatalogDialog(context);
              } else if (val == 'transparency') {
                AffiliateDisclosureDialog.show(context);
              }
            },
            itemBuilder: (ctx) => [
              if (provider.completedCount > 0)
                const PopupMenuItem(
                  value: 'clear_completed',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: AppTheme.accentEmerald, size: 18),
                      SizedBox(width: 10),
                      Text('Clear Completed', style: TextStyle(fontSize: 13.5)),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'add_store',
                child: Row(
                  children: [
                    Icon(Icons.add_business_rounded, color: AppTheme.accentEmerald, size: 18),
                    SizedBox(width: 10),
                    Text('Add Custom Store / Website', style: TextStyle(fontSize: 13.5)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    const Icon(Icons.store_rounded, color: AppTheme.accentCyan, size: 18),
                    const SizedBox(width: 10),
                    Text('Stores Directory (${StoreCatalog.allStores.length + provider.customStores.length})',
                        style: const TextStyle(fontSize: 13.5)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'transparency',
                child: Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: AppTheme.accentEmerald, size: 18),
                    SizedBox(width: 10),
                    Text('About & Affiliate Disclosure', style: TextStyle(fontSize: 13.5)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: AppTheme.accentRose, size: 18),
                    SizedBox(width: 10),
                    Text('Clear All Items', style: TextStyle(color: AppTheme.accentRose, fontSize: 13.5)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stats / Metrics Header Banner
            _buildStatsHeader(context, provider),

            // Horizontal Category Filter Carousel
            _buildCategoryFilters(context, provider),

            const SizedBox(height: 6),

            // Virtualized Item List or Empty State
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.accentEmerald,
                      ),
                    )
                  : provider.filteredItems.isEmpty
                      ? _buildEmptyState(context, provider)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: provider.filteredItems.length,
                          itemBuilder: (ctx, index) {
                            final item = provider.filteredItems[index];
                            return ShoppingItemTile(item: item);
                          },
                        ),
            ),

            // Bottom Add Item Bar
            const AddItemBar(),
          ],
        ),
      ),
    );
  }

  /// Builds the summary metrics dashboard (Active to buy, Completed, Universal store count, and completion progress)
  Widget _buildStatsHeader(BuildContext context, ShoppingProvider provider) {
    final theme = AppTheme.of(context);
    final totalItems = provider.totalCount;
    final activeItems = provider.activeCount;
    final completedItems = provider.completedCount;
    final totalStoreCount =
        StoreCatalog.allStores.length + provider.customStores.length;
    final progress = totalItems == 0 ? 0.0 : (completedItems / totalItems);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Active Items Stat Card
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentEmerald.withValues(alpha: 0.12),
                        theme.cardSurface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.accentEmerald.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.5),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.accentEmerald.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: AppTheme.accentEmerald,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$activeItems',
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const Text(
                              'To Buy',
                              style: TextStyle(
                                color: AppTheme.accentEmerald,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Completed Items Stat Card
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: theme.cardSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: completedItems > 0
                          ? AppTheme.accentCyan.withValues(alpha: 0.25)
                          : theme.borderSubtle.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.5),
                        decoration: BoxDecoration(
                          color: (completedItems > 0
                                  ? AppTheme.accentCyan
                                  : theme.textMuted)
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 14,
                          color: completedItems > 0
                              ? AppTheme.accentCyan
                              : theme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$completedItems',
                              style: TextStyle(
                                color: completedItems > 0
                                    ? theme.textPrimary
                                    : theme.textMuted,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Done',
                              style: TextStyle(
                                color: completedItems > 0
                                    ? AppTheme.accentCyan
                                    : theme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Live Universal Stores Counter Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                decoration: BoxDecoration(
                  color: theme.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.borderSubtle.withValues(alpha: 0.6),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentCyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$totalStoreCount',
                          style: const TextStyle(
                            color: AppTheme.accentCyan,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'STORES',
                      style: TextStyle(
                        color: theme.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (totalItems > 0) ...[
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 2.5,
                backgroundColor: theme.cardSurface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0
                      ? AppTheme.accentEmerald
                      : AppTheme.accentCyan,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the horizontal category filtering chips
  Widget _buildCategoryFilters(BuildContext context, ShoppingProvider provider) {
    final theme = AppTheme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ProductCategory.values.map((cat) {
          final isSelected = provider.selectedCategoryFilter == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: cat != ProductCategory.all
                  ? Icon(
                      cat.icon,
                      size: 14,
                      color: isSelected ? Colors.black : cat.accentColor,
                    )
                  : null,
              label: Text(cat.displayName),
              selected: isSelected,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : theme.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              selectedColor: cat.accentColor,
              backgroundColor: theme.cardBg,
              side: BorderSide(
                color: isSelected ? cat.accentColor : theme.borderSubtle,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (selected) {
                if (selected) {
                  provider.setCategoryFilter(cat);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Renders a friendly empty state illustration when 0 items match the view
  Widget _buildEmptyState(BuildContext context, ShoppingProvider provider) {
    final theme = AppTheme.of(context);
    final isFiltered = provider.selectedCategoryFilter != ProductCategory.all;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: theme.borderSubtle),
              ),
              child: Icon(
                isFiltered ? Icons.filter_alt_off_rounded : Icons.shopping_basket_outlined,
                size: 48,
                color: AppTheme.accentEmerald.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered
                  ? 'No items in ${provider.selectedCategoryFilter.displayName}'
                  : 'Your Smart List is Empty',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Switch back to "All Items" or add a new item below.'
                  : 'Type an item below like "Nike Air Max 270" or "MacBook Air" to explore live prices across 28+ online stores!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textMuted,
                fontSize: 13.5,
              ),
            ),
            if (isFiltered) ...[
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => provider.setCategoryFilter(ProductCategory.all),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.accentEmerald),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View All Items',
                  style: TextStyle(color: AppTheme.accentEmerald),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Confirmation dialog guarding bulk list clearance
  void _confirmClearAll(BuildContext context, ShoppingProvider provider) {
    final theme = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.borderSubtle),
        ),
        title: Text(
          'Clear all items?',
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This will remove all items from your shopping list.',
          style: TextStyle(color: theme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: theme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accentRose,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              provider.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
