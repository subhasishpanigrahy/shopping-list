import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/product_category.dart';
import '../models/store_info.dart';
import '../providers/shopping_provider.dart';
import '../services/store_url_helper.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// FILE: add_custom_store_sheet.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Solves the user's need to add missing websites or local stores (Idea 1 + Idea 2).
/// Merges smart URL parsing with a friction-free UI so users can simply paste
/// a website (e.g. `decathlon.in`), auto-extract the domain, generate the search
/// template and logo, and save it as a first-class shopping destination.
///
/// WHAT IT DOES:
/// 1. Accepts a store name and website/URL from the user.
/// 2. In real time, uses [StoreUrlHelper] to extract the domain, build the
///    `{query}` template, fetch the logo, and suggest a store name.
/// 3. Renders a live preview card showing how the store will look.
/// 4. Provides category and brand color selectors.
/// 5. Includes an expandable advanced drawer for deep-link schemes.
/// 6. Persists the store via [ShoppingProvider.addCustomStore].
/// ============================================================================
class AddCustomStoreSheet extends StatefulWidget {
  final ProductCategory? initialCategory;

  const AddCustomStoreSheet({super.key, this.initialCategory});

  static Future<void> show(BuildContext context, {ProductCategory? category}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 480),
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddCustomStoreSheet(initialCategory: category),
    );
  }

  @override
  State<AddCustomStoreSheet> createState() => _AddCustomStoreSheetState();
}

class _AddCustomStoreSheetState extends State<AddCustomStoreSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _customQueryController = TextEditingController();
  final _deepLinkController = TextEditingController();

  late ProductCategory _selectedCategory;
  Color _selectedColor = AppTheme.accentEmerald;
  bool _showAdvanced = false;
  String _previewDomain = '';
  String _generatedSearchUrl = '';
  String _previewLogoUrl = '';

  static const List<Color> _colorPresets = [
    AppTheme.accentEmerald,
    AppTheme.accentCyan,
    AppTheme.accentIndigo,
    AppTheme.accentRose,
    AppTheme.accentAmber,
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Teal
    Color(0xFFF97316), // Orange
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? ProductCategory.general;
    if (_selectedCategory == ProductCategory.all) {
      _selectedCategory = ProductCategory.general;
    }
    _urlController.addListener(_onUrlChanged);
  }

  @override
  void dispose() {
    _urlController.removeListener(_onUrlChanged);
    _nameController.dispose();
    _urlController.dispose();
    _customQueryController.dispose();
    _deepLinkController.dispose();
    super.dispose();
  }

  void _onUrlChanged() {
    final rawUrl = _urlController.text.trim();
    if (rawUrl.isEmpty) {
      setState(() {
        _previewDomain = '';
        _generatedSearchUrl = '';
        _previewLogoUrl = '';
      });
      return;
    }

    final domain = StoreUrlHelper.extractDomain(rawUrl);
    final searchUrl = StoreUrlHelper.buildSearchUrlTemplate(rawUrl);
    final logo = StoreUrlHelper.buildLogoUrl(domain);

    setState(() {
      _previewDomain = domain;
      _generatedSearchUrl = searchUrl;
      _previewLogoUrl = logo;

      // Auto-suggest name if empty
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = StoreUrlHelper.suggestStoreName(domain);
      }
    });
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final rawUrl = _urlController.text.trim();
    final searchUrl = _customQueryController.text.trim().isNotEmpty
        ? _customQueryController.text.trim()
        : StoreUrlHelper.buildSearchUrlTemplate(rawUrl);
    final deepLink = _deepLinkController.text.trim().isNotEmpty
        ? _deepLinkController.text.trim()
        : null;

    final newStore = StoreInfo(
      id: 'custom_${const Uuid().v4()}',
      name: name,
      category: _selectedCategory,
      webSearchUrlTemplate: searchUrl,
      deepLinkScheme: deepLink,
      logoUrl: _previewLogoUrl.isNotEmpty
          ? _previewLogoUrl
          : StoreUrlHelper.buildLogoUrl(rawUrl),
      brandColor: _selectedColor,
      isCustom: true,
      badgeText: '⭐ Custom Store',
      tagline: 'Direct web search on $name',
    );

    context.read<ShoppingProvider>().addCustomStore(newStore);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$name" to your online stores!'),
        backgroundColor: AppTheme.accentEmerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      decoration: BoxDecoration(
        color: theme.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: theme.borderSubtle, width: 1.5),
          left: BorderSide(color: theme.borderSubtle, width: 1.5),
          right: BorderSide(color: theme.borderSubtle, width: 1.5),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: theme.borderActive,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.accentEmerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.accentEmerald.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.add_business_rounded,
                      color: theme.accentEmerald,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Custom Store or Website',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Paste any shopping website — we auto-format it',
                          style: TextStyle(
                            color: theme.textMuted,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 1. Website or Domain Input
              Text(
                'Store Website or Domain',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _urlController,
                style: TextStyle(color: theme.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. decathlon.in, etsy.com, or search URL',
                  hintStyle: TextStyle(color: theme.textMuted),
                  prefixIcon: Icon(Icons.language_rounded, color: theme.accentCyan, size: 20),
                  suffixIcon: _urlController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, size: 18, color: theme.textMuted),
                          onPressed: () => _urlController.clear(),
                        )
                      : null,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a website or domain';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 2. Store Display Name
              Text(
                'Store Name',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: theme.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. Decathlon, VegNonVeg, Etsy',
                  hintStyle: TextStyle(color: theme.textMuted),
                  prefixIcon: Icon(Icons.store_rounded, color: theme.accentEmerald, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a store name';
                  }
                  return null;
                },
              ),

              // 3. Live Smart Preview Card (if domain detected)
              if (_previewDomain.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selectedColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _selectedColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _selectedColor.withValues(alpha: 0.3)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _previewLogoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: _selectedColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text
                                      : _previewDomain,
                                  style: TextStyle(
                                    color: theme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: _selectedColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '⭐ Custom',
                                    style: TextStyle(
                                      color: _selectedColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _generatedSearchUrl,
                              style: TextStyle(
                                color: theme.textMuted,
                                fontSize: 11.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // 4. Category Selector
              Text(
                'Department / Category',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ProductCategory.values
                    .where((c) => c != ProductCategory.all)
                    .map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    selected: isSelected,
                    avatar: Icon(cat.icon, size: 14, color: isSelected ? Colors.black : cat.accentColor),
                    label: Text(cat.displayName),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : theme.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    selectedColor: cat.accentColor,
                    backgroundColor: theme.cardSurface,
                    side: BorderSide(
                      color: isSelected ? cat.accentColor : theme.borderSubtle,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                          _selectedColor = cat.accentColor;
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 5. Brand Color Picker Chips
              Text(
                'Brand Theme Color',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: _colorPresets.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? (theme.isDark ? Colors.white : Colors.black)
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 16, color: Colors.black)
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 6. Advanced Settings Expandable Accordion
              InkWell(
                onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        _showAdvanced ? Icons.expand_less : Icons.tune_rounded,
                        size: 18,
                        color: theme.accentCyan,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _showAdvanced ? 'Hide Advanced Settings' : 'Advanced Settings (URL Template & App Deep Link)',
                        style: TextStyle(
                          color: theme.accentCyan,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_showAdvanced) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _customQueryController,
                  style: TextStyle(color: theme.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Custom Search URL (use {query} placeholder)',
                    labelStyle: TextStyle(color: theme.textSecondary),
                    hintText: 'https://site.com/search?q={query}',
                    hintStyle: TextStyle(color: theme.textMuted),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _deepLinkController,
                  style: TextStyle(color: theme.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Native App Deep Link Scheme (Optional)',
                    labelStyle: TextStyle(color: theme.textSecondary),
                    hintText: 'e.g. app://search?q={query}',
                    hintStyle: TextStyle(color: theme.textMuted),
                    isDense: true,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 7. Save CTA Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentEmerald,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add to My Online Stores',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
