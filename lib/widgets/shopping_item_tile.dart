import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store_catalog.dart';
import '../models/shopping_item.dart';
import '../providers/shopping_provider.dart';
import '../theme/app_theme.dart';
import 'store_sheet.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final provider = context.read<ShoppingProvider>();
    final matchingStores = StoreCatalog.getPrioritizedStores(
      query: item.title,
      category: item.category,
      detectedBrand: item.brand,
      customStores: provider.customStores,
    ).relevantStores;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.accentRose.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentRose.withValues(alpha: 0.5)),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.accentRose,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.accentRose,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        provider.removeItem(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed "${item.title}"'),
            action: SnackBarAction(
              label: 'Undo',
              textColor: AppTheme.accentEmerald,
              onPressed: () {
                provider.addItem(
                  item.title,
                  customCategory: item.category,
                  customBrand: item.brand,
                  notes: item.notes,
                  quantity: item.quantity,
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isChecked
                ? theme.borderSubtle.withValues(alpha: 0.5)
                : theme.borderSubtle,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => StoreSheet.show(context, item),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Strike-through toggle Checkbox
                  GestureDetector(
                    key: ValueKey('checkbox_${item.id}'),
                    onTap: () => provider.toggleItem(item.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: item.isChecked
                            ? AppTheme.accentEmerald
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: item.isChecked
                              ? AppTheme.accentEmerald
                              : theme.textMuted,
                          width: 2,
                        ),
                      ),
                      child: item.isChecked
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.black,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Item Title and Tags
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: item.isChecked
                                ? theme.textMuted
                                : theme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: theme.textMuted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: item.category.accentColor.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: item.category.accentColor.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.category.icon,
                                    size: 11,
                                    color: item.category.accentColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.category.displayName,
                                    style: TextStyle(
                                      color: item.category.accentColor,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Brand Badge if detected
                            if (item.brand != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.cardSurface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: theme.borderActive,
                                  ),
                                ),
                                child: Text(
                                  item.brand!,
                                  style: TextStyle(
                                    color: theme.textSecondary,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Store Aggregator Trigger Button
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => StoreSheet.show(context, item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentEmerald.withValues(alpha: 0.15),
                            AppTheme.accentCyan.withValues(alpha: 0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.accentEmerald.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.storefront_rounded,
                            size: 15,
                            color: AppTheme.accentEmerald,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${matchingStores.length} Stores',
                            style: const TextStyle(
                              color: AppTheme.accentEmerald,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppTheme.accentEmerald,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
