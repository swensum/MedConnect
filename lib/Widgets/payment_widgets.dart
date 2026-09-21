import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/payment_models.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (method) {
      case PaymentMethod.esewa:
        return Icons.account_balance_wallet_rounded;
      case PaymentMethod.khalti:
        return Icons.payments_rounded;
      case PaymentMethod.cash:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(
            distance: selected ? 2 : 4,
            blur: selected ? 5 : 9,
            inset: selected,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.15) : kNeuBg,
                shape: BoxShape.circle,
                boxShadow: selected
                    ? null
                    : neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(
                _icon,
                size: 18.sp,
                color: selected ? Colors.white : AppColors.navy,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    method.sublabel,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 20.sp,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PaymentMethod.values.map((m) {
        return PaymentMethodTile(
          method: m,
          selected: selected == m,
          onTap: () => onSelect(m),
        );
      }).toList(),
    );
  }
}