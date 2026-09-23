import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';

/// Shared surface token for every neumorphic screen. Keeping this in one
/// place means a background change is a one-line edit, not a find-replace
/// across every auth screen.
const Color kNeuBg = AppColors.paleBlue;

/// Two soft, large-blur shadows — dark bottom-right + light top-left — is
/// the neumorphic trick. `inset` swaps the corners to fake a "pressed/
/// carved in" surface. Only looks right when the element sits flush on
/// kNeuBg (or another same-color surface) — the white highlight shadow
/// needs a matching background to blend into.
List<BoxShadow> neuShadows({
  required double distance,
  required double blur,
  bool inset = false,
}) {
  final darkOffset = inset
      ? Offset(-distance, -distance)
      : Offset(distance, distance);
  final lightOffset = inset
      ? Offset(distance, distance)
      : Offset(-distance, -distance);

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

/// A single soft dark shadow for elements that float over a dimmed
/// scrim/barrier (dialogs, sheets shown with a barrier) rather than
/// sitting flush on the page background. neuShadows()'s white highlight
/// shadow has nothing matching to blend into over a dark backdrop and
/// reads as a bright glow — this avoids that.
List<BoxShadow> neuFloatingShadow({double blur = 24, double distance = 8}) {
  return [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.18),
      offset: Offset(0, distance),
      blurRadius: blur,
    ),
  ];
}

InputDecoration bareInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodySecondary,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    filled: false,
    isDense: true,
    contentPadding: EdgeInsets.zero,
  );
}

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
            fontWeight: FontWeight.w600,
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

/// Tap-to-upload tile for verification documents. Empty state shows an
/// inset "add" surface; once a file is attached it flips to a filled
/// state with the file name and a checkmark. Reusable anywhere the app
/// needs a document/photo upload (KYC now, medical reports/X-rays later).
class NeuUploadTile extends StatelessWidget {
  const NeuUploadTile({
    super.key,
    required this.label,
    required this.onTap,
    this.fileName,
    this.sublabel,
  });

  final String label;
  final String? sublabel;
  final String? fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final uploaded = fileName != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 4, blur: 9, inset: uploaded),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: uploaded
                    ? Color.lerp(kNeuBg, AppColors.navy, 0.06)
                    : kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(
                uploaded ? Icons.check : Icons.upload_file_outlined,
                size: 18.sp,
                color: AppColors.navy,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    uploaded ? fileName! : (sublabel ?? 'Tap to upload'),
                    style: AppTextStyles.caption.copyWith(
                      color: uploaded
                          ? AppColors.navy
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              uploaded ? Icons.refresh : Icons.chevron_right,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// A raised neumorphic circle with a checkmark that pops in with a small,
/// satisfying bounce. Use this for any "action succeeded" moment — OTP
/// verified, booking confirmed, KYC submitted, etc. — not just here.
class NeuSuccessCheck extends StatelessWidget {
  const NeuSuccessCheck({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: kNeuBg,
          shape: BoxShape.circle,
          boxShadow: neuShadows(distance: 7, blur: 16),
        ),
        child: Icon(
          Icons.check_rounded,
          size: (size * 0.45).sp,
          color: AppColors.success,
        ),
      ),
    );
  }
}

const List<String> _neuMonthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

Future<DateTime?> showNeuDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _NeuDatePickerSheet(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

/// A raised neumorphic circle with a continuously pulsing icon — use this
/// for "in progress / waiting" states (KYC review, payment processing,
/// etc.) as opposed to NeuSuccessCheck's one-shot bounce for completed
/// states.
class NeuPulseIcon extends StatefulWidget {
  const NeuPulseIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 96,
  });

  final IconData icon;
  final Color? color;
  final double size;

  @override
  State<NeuPulseIcon> createState() => _NeuPulseIconState();
}

class _NeuPulseIconState extends State<NeuPulseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.06);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: widget.size.w,
        height: widget.size.w,
        decoration: BoxDecoration(
          color: kNeuBg,
          shape: BoxShape.circle,
          boxShadow: neuShadows(distance: 7, blur: 16),
        ),
        child: Icon(
          widget.icon,
          size: (widget.size * 0.4).sp,
          color: widget.color ?? AppColors.navy,
        ),
      ),
    );
  }
}

class NeuBottomNavItem {
  const NeuBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// A floating, pill-shaped bottom nav bar consistent with the neumorphic
/// language elsewhere in the app. The active tab expands into a filled
/// navy pill with a label; inactive tabs are icon-only.
class NeuBottomNavBar extends StatelessWidget {
  const NeuBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NeuBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: neuShadows(distance: 6, blur: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == currentIndex;
          final item = items[i];
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: selected ? 18.w : 12.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.navy : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? item.activeIcon : item.icon,
                    size: 20.sp,
                    color: selected ? AppColors.white : AppColors.textSecondary,
                  ),
                  if (selected) ...[
                    SizedBox(width: 6.w),
                    Text(
                      item.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NeuDatePickerSheet extends StatefulWidget {
  const _NeuDatePickerSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_NeuDatePickerSheet> createState() => _NeuDatePickerSheetState();
}

class _NeuDatePickerSheetState extends State<_NeuDatePickerSheet> {
  late int _day = widget.initialDate.day;
  late int _month = widget.initialDate.month;
  late int _year = widget.initialDate.year;

  late final FixedExtentScrollController _dayController =
      FixedExtentScrollController(initialItem: _day - 1);
  late final FixedExtentScrollController _monthController =
      FixedExtentScrollController(initialItem: _month - 1);
  late final FixedExtentScrollController _yearController =
      FixedExtentScrollController(initialItem: _year - widget.firstDate.year);

  int get _yearCount => widget.lastDate.year - widget.firstDate.year + 1;
  int get _daysInSelectedMonth => DateTime(_year, _month + 1, 0).day;

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _confirm() {
    final clampedDay = _day.clamp(1, _daysInSelectedMonth);
    Navigator.of(context).pop(DateTime(_year, _month, clampedDay));
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int index) labelBuilder,
    required ValueChanged<int> onChanged,
  }) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Highlight box sits behind the picker so the picker's own text
          // renders on top of it instead of being covered.
          Container(
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: kNeuBg,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: neuShadows(distance: 3, blur: 6, inset: true),
            ),
          ),
          CupertinoPicker(
            selectionOverlay: null, // kill the default grey iOS bar
            backgroundColor: Colors.transparent,
            diameterRatio: 3.0,
            useMagnifier: false,
            scrollController: controller,
            itemExtent: 40.h,
            onSelectedItemChanged: onChanged,
            children: List.generate(itemCount, (i) {
              return Center(
                child: Text(
                  labelBuilder(i),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.mutedBlue.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    'Select date of birth',
                    style: AppTextStyles.h2.copyWith(fontSize: 17.sp),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 200.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    _wheel(
                      controller: _dayController,
                      itemCount: 31,
                      labelBuilder: (i) => '${i + 1}',
                      onChanged: (i) => setState(() => _day = i + 1),
                    ),
                    SizedBox(width: 8.w),
                    _wheel(
                      controller: _monthController,
                      itemCount: 12,
                      labelBuilder: (i) => _neuMonthNames[i],
                      onChanged: (i) => setState(() => _month = i + 1),
                    ),
                    SizedBox(width: 8.w),
                    _wheel(
                      controller: _yearController,
                      itemCount: _yearCount,
                      labelBuilder: (i) => '${widget.firstDate.year + i}',
                      onChanged: (i) =>
                          setState(() => _year = widget.firstDate.year + i),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: NeuPillButton(
                enabled: true,
                onTap: _confirm,
                label: 'Confirm',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A neumorphic confirmation dialog — same soft-surface language as the
/// rest of the app, instead of the stock Material AlertDialog. Use for
/// any destructive/irreversible action (cancel appointment, delete, etc).
///
/// Returns true if the destructive action was confirmed, false/null
/// otherwise.
Future<bool?> showNeuConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Go back',
  IconData icon = Icons.warning_amber_rounded,
  Color? iconColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.25),
    builder: (dialogContext) => _NeuConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      icon: icon,
      iconColor: iconColor,
    ),
  );
}

class _NeuConfirmDialog extends StatelessWidget {
  const _NeuConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.icon,
    this.iconColor,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: neuFloatingShadow(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 3, blur: 8, inset: true),
              ),
              child: Icon(
                icon,
                size: 26.sp,
                color: iconColor ?? AppColors.danger,
              ),
            ),
            SizedBox(height: 18.h),
            Text(title, textAlign: TextAlign.center, style: AppTextStyles.h3),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary.copyWith(height: 1.45),
            ),
            SizedBox(height: 24.h),
            NeuPillButton(
              enabled: true,
              height: 48,
              onTap: () => Navigator.of(context).pop(true),
              label: confirmLabel,
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  cancelLabel,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
