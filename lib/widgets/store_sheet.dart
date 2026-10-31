import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/store_catalog.dart';
import '../models/product_category.dart';
import '../models/shopping_item.dart';
import '../models/store_info.dart';
import '../providers/shopping_provider.dart';
import '../services/category_detector.dart';
import '../services/store_router.dart';
import '../theme/app_theme.dart';
import 'add_custom_store_sheet.dart';
import 'store_card.dart';

/// ============================================================================
/// FILE: store_sheet.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// This bottom sheet is the operational realization of the app's mission:
/// making **External Websites First-Class Citizens**. When a user selects an
/// item, this modal presents every major online destination across the web,
/// seamlessly integrating user-added custom stores alongside the built-in catalog.
///
/// WHAT IT DOES:
/// 1. Asynchronously resolves which stores have native apps installed on the device.
/// 2. Merges user-added custom stores (Idea 1 + Idea 2) into the store directory.
/// 3. Partitions results into clear sections:
///    - **📱 Installed on Your Phone** (Immediate 1-tap native app deep links).
///    - **🌐 Top Online Stores & Official Websites** (1-tap In-App Browser views).
/// 4. Provides a direct "+ Add Store" button so users can instantly plug in any
///    missing boutique or regional website while comparing prices.
/// 5. Inline search refinement bar to tweak query terms.
/// ============================================================================

enum StoreSheetFilter {
  all('All Stores'),
  installed('📱 Installed'),
  official('⭐ Official & Brand'),
  custom('⭐ My Stores'),
  categoryOnly('🎯 Matched Category');

  final String label;
  const StoreSheetFilter(this.label);
}

class StoreSheet extends StatefulWidget {
  final ShoppingItem item;

  const StoreSheet({super.key, required this.item});

  /// Static convenience helper to display the sheet modally.
  static Future<void> show(BuildContext context, ShoppingItem item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StoreSheet(item: item),
    );
  }

  @override
  State<StoreSheet> createState() => _StoreSheetState();
}

class _StoreSheetState extends State<StoreSheet> {
  late TextEditingController _queryController;
  StoreSheetFilter _currentFilter = StoreSheetFilter.all;
  Map<String, bool> _installedStatus = {};
  bool _showOtherStores = false;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: widget.item.title);
    _checkAppInstallations();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  /// Runs asynchronous OS checks via url_launcher to verify app installations
  Future<void> _checkAppInstallations() async {
    final customStores = context.read<ShoppingProvider>().customStores;
    final allStores = [
      ...customStores,
      ...StoreCatalog.allStores,
    ];

    final status = await StoreRouter.checkInstalledStores(allStores);
    if (mounted) {
      setState(() {
        _installedStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final provider = context.watch<ShoppingProvider>();
    final customStores = provider.customStores;

    final currentQuery = _queryController.text.trim();
    final effectiveQuery =
        currentQuery.isNotEmpty ? currentQuery : widget.item.title;

    final dynamicDetection = currentQuery.isNotEmpty
        ? CategoryDetector.detect(currentQuery)
        : null;
    final effectiveCategory = dynamicDetection != null &&
            dynamicDetection.category != ProductCategory.general
        ? dynamicDetection.category
        : (widget.item.category != ProductCategory.general
            ? widget.item.category
            : CategoryDetector.detect(effectiveQuery).category);
    final effectiveBrand = dynamicDetection?.brand ?? widget.item.brand;

    final relevance = StoreCatalog.getPrioritizedStores(
      query: effectiveQuery,
      category: effectiveCategory,
      detectedBrand: effectiveBrand,
      customStores: customStores,
    );

    final relevantStores = relevance.relevantStores;
    final rawOtherStores = relevance.otherStores;

    // In case user filters by tabs:
    final allStoresOrdered = relevance.allOrdered;
    final allInstalled =
        allStoresOrdered.where((s) => _installedStatus[s.id] == true).toList();

    // Filter installed vs web for relevant stores:
    // Any installed multi-category app on the phone is prominently surfaced!
    final installedRelevant = allStoresOrdered.where((s) {
      if (_installedStatus[s.id] != true) return false;
      // Do not surface single-brand official stores unless their brand matches
      if (s.isVerifiedOfficial && !relevantStores.contains(s)) return false;
      return true;
    }).toList();

    final webRelevant =
        relevantStores.where((s) => _installedStatus[s.id] != true).toList();

    // The otherStores section only holds uninstalled, non-matching specialty stores
    final otherStores = rawOtherStores
        .where((s) => !installedRelevant.contains(s))
        .toList();

    // Apply active filter tab
    List<StoreInfo> displayedStores = allStoresOrdered;
    if (_currentFilter == StoreSheetFilter.installed) {
      displayedStores = allInstalled;
    } else if (_currentFilter == StoreSheetFilter.official) {
      displayedStores =
          allStoresOrdered.where((s) => s.isVerifiedOfficial).toList();
    } else if (_currentFilter == StoreSheetFilter.custom) {
      displayedStores = allStoresOrdered.where((s) => s.isCustom).toList();
    } else if (_currentFilter == StoreSheetFilter.categoryOnly) {
      displayedStores = allStoresOrdered
          .where((s) => s.category == widget.item.category)
          .toList();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: theme.borderSubtle, width: 1.5),
              left: BorderSide(color: theme.borderSubtle, width: 1.5),
              right: BorderSide(color: theme.borderSubtle, width: 1.5),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: AppTheme.borderActive,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),

              // Sheet Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.item.category.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.item.category.accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        widget.item.category.icon,
                        color: widget.item.category.accentColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Universal Store Aggregator',
                            style: TextStyle(
                              color: AppTheme.accentEmerald,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            widget.item.title,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Add Custom Store',
                      icon: const Icon(Icons.add_business_rounded, color: AppTheme.accentEmerald),
                      onPressed: () => AddCustomStoreSheet.show(context, category: widget.item.category),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: theme.textMuted),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Search Refinement Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.isDark ? theme.cardBg : theme.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.borderSubtle),
                  ),
                  child: TextField(
                    controller: _queryController,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
                    ),
                    onChanged: (val) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Refine search keywords...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                      suffixIcon: _queryController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: AppTheme.textMuted,
                                size: 18,
                              ),
                              onPressed: () {
                                _queryController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: StoreSheetFilter.values.map((filter) {
                    final isSelected = _currentFilter == filter;
                    int count = allStoresOrdered.length;
                    if (filter == StoreSheetFilter.installed) {
                      count = allInstalled.length;
                    } else if (filter == StoreSheetFilter.official) {
                      count = allStoresOrdered
                          .where((s) => s.isVerifiedOfficial)
                          .length;
                    } else if (filter == StoreSheetFilter.custom) {
                      count =
                          allStoresOrdered.where((s) => s.isCustom).length;
                    } else if (filter == StoreSheetFilter.categoryOnly) {
                      count = allStoresOrdered
                          .where((s) => s.category == widget.item.category)
                          .length;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text('${filter.label} ($count)'),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : theme.textSecondary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        backgroundColor: theme.cardSurface,
                        selectedColor: theme.accentEmerald,
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? theme.accentEmerald
                              : theme.borderSubtle,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _currentFilter = filter;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),
              Divider(color: theme.borderSubtle, height: 1),

              // Store Lists
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  children: [
                    if (_currentFilter == StoreSheetFilter.all) ...[
                      // 📱 Installed Apps Section (rendered when device has matching native shopping apps)
                      if (installedRelevant.isNotEmpty) ...[
                        _buildSectionHeader(
                          context: context,
                          title: '📱 Installed on Your Phone',
                          count: installedRelevant.length,
                          subtitle: 'Top matching native apps on your device',
                          accentColor: theme.accentEmerald,
                        ),
                        const SizedBox(height: 10),
                        ...installedRelevant.map((store) => StoreCard(
                              store: store,
                              query: effectiveQuery,
                              isInstalled: true,
                              isHighlighted: true,
                              onDelete: store.isCustom
                                  ? () => provider.removeCustomStore(store.id)
                                  : null,
                            )),
                        const SizedBox(height: 20),
                      ],

                      // 🌐 Top Online Stores & Official Websites Section
                      if (webRelevant.isNotEmpty) ...[
                        _buildSectionHeader(
                          context: context,
                          title: '🌐 Top Matching Online Stores',
                          count: webRelevant.length,
                          subtitle:
                              'Sleek in-app web view • Verified sellers for this item',
                          accentColor: theme.accentIndigo,
                        ),
                        const SizedBox(height: 10),

                        // Display relevant web stores with official brand portals prioritized
                        ...webRelevant.map((store) {
                          final isOfficial = store.isVerifiedOfficial &&
                              (widget.item.brand != null &&
                                  store.associatedBrands.any((b) =>
                                      b.toLowerCase().contains(
                                          widget.item.brand!.toLowerCase())));

                          return StoreCard(
                            store: store,
                            query: effectiveQuery,
                            isInstalled: false,
                            isHighlighted: isOfficial,
                            onDelete: store.isCustom
                                ? () => provider.removeCustomStore(store.id)
                                : null,
                          );
                        }),
                        const SizedBox(height: 16),
                      ],

                      // 📦 Collapsible Section for Other Stores
                      if (otherStores.isNotEmpty) ...[
                        _buildOtherStoresCollapsible(
                          otherStores: otherStores,
                          effectiveQuery: effectiveQuery,
                          provider: provider,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ] else ...[
                      // Explicit Filtered List
                      ...displayedStores.map((store) => StoreCard(
                            store: store,
                            query: effectiveQuery,
                            isInstalled: _installedStatus[store.id] == true,
                            isHighlighted: store.isVerifiedOfficial,
                            onDelete: store.isCustom
                                ? () => provider.removeCustomStore(store.id)
                                : null,
                          )),
                    ],

                    const SizedBox(height: 12),

                    // "+ Add Custom Store" Interactive Button at bottom of sheet
                    _buildAddStorePrompt(context),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherStoresCollapsible({
    required List<StoreInfo> otherStores,
    required String effectiveQuery,
    required ShoppingProvider provider,
  }) {
    final theme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.isDark ? theme.cardSurface.withValues(alpha: 0.5) : theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _showOtherStores = !_showOtherStores),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.isDark ? theme.cardBg : theme.cardSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.borderSubtle),
                      ),
                      child: Icon(
                        _showOtherStores
                            ? Icons.unfold_less_rounded
                            : Icons.unfold_more_rounded,
                        color: theme.textSecondary,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _showOtherStores
                                ? 'Hide Non-Matching Stores'
                                : 'Show Other Stores (${otherStores.length})',
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _showOtherStores
                                ? 'Showing all catalog stores'
                                : 'Single-brand & specialty stores unlikely to carry this item',
                            style: TextStyle(
                              color: theme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _showOtherStores
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: theme.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showOtherStores) ...[
            Divider(color: theme.borderSubtle, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Column(
                children: otherStores.map((store) {
                  final isInstalled = _installedStatus[store.id] == true;
                  return StoreCard(
                    store: store,
                    query: effectiveQuery,
                    isInstalled: isInstalled,
                    isHighlighted: false,
                    onDelete: store.isCustom
                        ? () => provider.removeCustomStore(store.id)
                        : null,
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddStorePrompt(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.accentEmerald.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => AddCustomStoreSheet.show(context, category: widget.item.category),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.accentEmerald.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: theme.accentEmerald,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Missing a website or local store?',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Paste any website domain to add it in 1 tap',
                        style: TextStyle(
                          color: theme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: theme.accentEmerald,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required int count,
    required String subtitle,
    required Color accentColor,
  }) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(
            color: theme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
