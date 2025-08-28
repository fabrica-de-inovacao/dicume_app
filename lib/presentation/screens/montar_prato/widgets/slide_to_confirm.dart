import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SlideToConfirm extends StatefulWidget {
  final VoidCallback onConfirmed;
  final String text;
  final double height;
  final double? maxWidth;

  const SlideToConfirm({
    super.key,
    required this.onConfirmed,
    this.text = 'Deslize para confirmar',
    this.height = 56.0,
    this.maxWidth,
  });

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> {
  double handlePos = 0.0;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final totalWidth = widget.maxWidth ?? (mq.size.width - 48);
    final trackWidth = totalWidth.clamp(0.0, double.infinity);
    final handleSize = widget.height;
    final maxTravel = (trackWidth - handleSize).clamp(0.0, double.infinity);

    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Track
          Container(
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          // Fill (progress)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: (handlePos + handleSize / 2).clamp(0.0, trackWidth),
              decoration: BoxDecoration(
                color:
                    _confirmed
                        ? AppColors.primary.withValues(alpha: 0.95)
                        : AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Handle
          AnimatedPositioned(
            duration: const Duration(milliseconds: 120),
            left: handlePos,
            child: GestureDetector(
              onHorizontalDragUpdate:
                  _confirmed
                      ? null
                      : (details) {
                        setState(() {
                          handlePos = (handlePos + details.delta.dx).clamp(
                            0.0,
                            maxTravel,
                          );
                        });
                      },
              onHorizontalDragEnd:
                  _confirmed
                      ? null
                      : (details) {
                        if (handlePos >= maxTravel * 0.85) {
                          setState(() {
                            handlePos = maxTravel;
                            _confirmed = true;
                          });
                          Future.delayed(const Duration(milliseconds: 250), () {
                            widget.onConfirmed();
                          });
                        } else {
                          setState(() => handlePos = 0.0);
                        }
                      },
              child: Container(
                width: handleSize,
                height: handleSize,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        _confirmed
                            ? const Icon(
                              Icons.check,
                              color: AppColors.onPrimary,
                              key: ValueKey('check'),
                            )
                            : const Icon(
                              Icons.chevron_right,
                              color: AppColors.onPrimary,
                              size: 28,
                              key: ValueKey('chev'),
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
