import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_category.dart';
import '../providers/shopping_provider.dart';
import '../services/category_detector.dart';
import '../theme/app_theme.dart';

class AddItemBar extends StatefulWidget {
  const AddItemBar({super.key});

  @override
  State<AddItemBar> createState() => _AddItemBarState();
}

class _AddItemBarState extends State<AddItemBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DetectionResult _detection = const DetectionResult(
    category: ProductCategory.general,
  );
  ProductCategory? _manualCategory;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    setState(() {
      _detection = CategoryDetector.detect(text);
      if (text.isEmpty) {
        _manualCategory = null;
      }
    });
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<ShoppingProvider>();
    provider.addItem(
      text,
      customCategory: _manualCategory,
      customBrand: _detection.brand,
    );

    _controller.clear();
    setState(() {
      _manualCategory = null;
      _detection = const DetectionResult(category: ProductCategory.general);
    });
    _focusNode.unfocus();
  }

  void _showCategoryPicker() {
    final theme = AppTheme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ProductCategory.values
                      .where((c) => c != ProductCategory.all)
                      .map((cat) {
                        final isSelected =
                            (_manualCategory ?? _detection.category) == cat;
                        return ChoiceChip(
                          selected: isSelected,
                          avatar: Icon(
                            cat.icon,
                            size: 16,
                            color: isSelected ? Colors.black : cat.accentColor,
                          ),
                          label: Text(cat.displayName),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : theme.textPrimary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          selectedColor: cat.accentColor,
                          backgroundColor: theme.cardSurface,
                          side: BorderSide(
                            color: isSelected
                                ? cat.accentColor
                                : theme.borderSubtle,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _manualCategory = cat;
                              });
                              Navigator.pop(ctx);
                            }
                          },
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final effectiveCategory = _manualCategory ?? _detection.category;
    final hasText = _controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.bg,
        border: Border(top: BorderSide(color: theme.borderSubtle, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live AI Detection Preview Tag
          if (hasText) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Auto-detected:',
                    style: TextStyle(
                      color: theme.textMuted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _showCategoryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: effectiveCategory.accentColor.withValues(
                          alpha: 0.18,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: effectiveCategory.accentColor.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            effectiveCategory.icon,
                            size: 13,
                            color: effectiveCategory.accentColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            effectiveCategory.displayName,
                            style: TextStyle(
                              color: effectiveCategory.accentColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 14,
                            color: effectiveCategory.accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_detection.brand != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentEmerald.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.accentEmerald.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 12,
                            color: AppTheme.accentEmerald,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _detection.brand!,
                            style: const TextStyle(
                              color: AppTheme.accentEmerald,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Input Bar
          Container(
            decoration: BoxDecoration(
              color: theme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasText
                    ? AppTheme.accentEmerald.withValues(alpha: 0.5)
                    : theme.borderSubtle,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(
                  Icons.add_shopping_cart_rounded,
                  color: hasText ? AppTheme.accentEmerald : theme.textMuted,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 15,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSubmit(),
                    decoration: InputDecoration(
                      hintText:
                          'Add item (e.g. Nike Air Max, MacBook, Butter)...',
                      hintStyle: TextStyle(
                        color: theme.textMuted,
                        fontSize: 14,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                if (hasText) ...[
                  IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: theme.textMuted,
                    ),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _manualCategory = null;
                        _detection = const DetectionResult(
                          category: ProductCategory.general,
                        );
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentEmerald,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: _handleSubmit,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: theme.cardSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.borderSubtle),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: theme.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
