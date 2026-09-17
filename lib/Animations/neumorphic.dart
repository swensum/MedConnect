import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';

const Color kNeuBg = AppColors.paleBlue;

/// Two soft, large-blur shadows — dark bottom-right + light top-left — is
/// the neumorphic trick. `inset` swaps the corners to fake a "pressed/
/// carved in" surface.
List<BoxShadow> neuShadows({
  required double distance,
  required double blur,
  bool inset = false,
}) {
  final darkOffset =
      inset ? Offset(-distance, -distance) : Offset(distance, distance);
  final lightOffset =
      inset ? Offset(distance, distance) : Offset(-distance, -distance);

  return [
    BoxShadow(
      color: const Color(0xFFA9BBCF).withValues(alpha: 0.65),
      offset: darkOffset,
      blurRadius: blur,
      spreadRadius: 0.5,
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.9),
      offset: lightOffset,
      blurRadius: blur,
      spreadRadius: 0.5,
    ),
  ];
}

/// A raised neumorphic pill for primary submit actions. Supports an
/// optional loading state (swaps the label for a spinner) and an optional
/// trailing icon (e.g. an arrow on a "Get started" button). Height/radius
/// default to match the auth-flow screens but can be overridden per screen.
class NeuPillButton extends StatefulWidget {
  const NeuPillButton({
    super.key,
    required this.enabled,
    required this.onTap,
    required this.label,
    this.loading = false,
    this.icon,
    this.height,
    this.radius,
  });

  final bool enabled;
  final VoidCallback onTap;
  final String label;
  final bool loading;
  final IconData? icon;
  final double? height;
  final double? radius;

  @override
  State<NeuPillButton> createState() => _NeuPillButtonState();
}

class _NeuPillButtonState extends State<NeuPillButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool down = _pressed && widget.enabled;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: down ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          height: widget.height ?? 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.navy : kNeuBg,
            borderRadius: BorderRadius.circular((widget.radius ?? 16).r),
            boxShadow: neuShadows(
              distance: down ? 3 : 7,
              blur: down ? 6 : 16,
              inset: down,
            ),
          ),
          child: widget.loading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.navy),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: AppTextStyles.button.copyWith(
                        fontSize: 15.sp,
                        color: widget.enabled
                            ? AppColors.white
                            : AppColors.navy.withValues(alpha: 0.4),
                      ),
                    ),
                    if (widget.icon != null) ...[
                      SizedBox(width: 8.w),
                      Icon(
                        widget.icon,
                        size: 18.sp,
                        color: widget.enabled
                            ? AppColors.white
                            : AppColors.navy.withValues(alpha: 0.4),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// A raised neumorphic circular icon button — used for a compact "next"
/// action instead of a full-width pill (e.g. mid-onboarding navigation).
class NeuCircleButton extends StatefulWidget {
  const NeuCircleButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.size = 54,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double size;

  @override
  State<NeuCircleButton> createState() => _NeuCircleButtonState();
}

class _NeuCircleButtonState extends State<NeuCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size.w,
          height: widget.size.w,
          decoration: BoxDecoration(
            color: AppColors.navy,
            shape: BoxShape.circle,
            boxShadow: neuShadows(
              distance: _pressed ? 3 : 7,
              blur: _pressed ? 6 : 16,
              inset: _pressed,
            ),
          ),
          child: Icon(widget.icon, color: AppColors.white, size: 22.sp),
        ),
      ),
    );
  }
}

/// An inset ("carved in") neumorphic container — the standard surface for
/// anything the user types into or selects within.
class NeuInsetSurface extends StatelessWidget {
  const NeuInsetSurface({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.radius = 14,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(radius.r),
        boxShadow: neuShadows(distance: 3, blur: 6, inset: true),
      ),
      child: child,
    );
  }
}

/// A small raised chip used for single-select options (gender, blood type).
/// Selected chips press inward and take the navy fill.
class NeuChip extends StatelessWidget {
  const NeuChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.width,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: 44.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : kNeuBg,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: neuShadows(
            distance: selected ? 2 : 4,
            blur: selected ? 5 : 9,
            inset: selected,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 13.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.white : AppColors.navy,
          ),
        ),
      ),
    );
  }
}

/// Section label used above grouped form fields.
class NeuFieldLabel extends StatelessWidget {
  const NeuFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

/// Small raised pill confirming which role the user picked on the role
/// selection screen. Reused across phone entry, OTP, and doctor KYC.
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final label = role == UserRole.patient ? 'Patient' : 'Doctor';
    final icon = role == UserRole.patient
        ? Icons.person_outline
        : Icons.medical_services_outlined;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: neuShadows(distance: 4, blur: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.navy),
          SizedBox(width: 6.w),
          Text(
            'Signing up as $label',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}