import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

// ============================================================================
// DICUMÊ SUPER MODERN COMPONENTS
// Componentes vibrantes, regionais e acessíveis para o público alvo
// ============================================================================

// ============================================================================
// MODERN BOTTOM NAVIGATION BAR
// ============================================================================

class DicumeSuperModernBottomNavItem {
  final IconData icon;
  final String label;
  final String tooltip;

  const DicumeSuperModernBottomNavItem({
    required this.icon,
    required this.label,
    required this.tooltip,
  });
}

class DicumeSuperModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<DicumeSuperModernBottomNavItem> items;
  final Function(int) onTap;

  const DicumeSuperModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTap(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          gradient:
                              isSelected ? AppColors.primaryGradient : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                  : null,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                item.icon,
                                size: isSelected ? 28 : 24,
                                color:
                                    isSelected
                                        ? AppColors.surface
                                        : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: isSelected ? 12 : 10,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                color:
                                    isSelected
                                        ? AppColors.surface
                                        : AppColors.textSecondary,
                                fontFamily: 'Montserrat',
                              ),
                              child: Text(
                                item.label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MODERN CARD
// ============================================================================

class DicumeSuperModernCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? elevation;

  const DicumeSuperModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap != null
              ? () {
                HapticFeedback.lightImpact();
                onTap!();
              }
              : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MODERN BUTTON
// ============================================================================

class DicumeSuperModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isLoading;
  final EdgeInsets? padding;

  const DicumeSuperModernButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : null,
          foregroundColor: isOutlined ? AppColors.primary : AppColors.surface,
          elevation: isOutlined ? 0 : 8,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side:
                isOutlined
                    ? BorderSide(color: AppColors.primary, width: 2)
                    : BorderSide.none,
          ),
        ).copyWith(
          backgroundColor:
              isOutlined
                  ? WidgetStateProperty.all(Colors.transparent)
                  : WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.pressed)
                        ? AppColors.brown700
                        : AppColors.primary;
                  }),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOutlined ? AppColors.primary : AppColors.surface,
                    ),
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
