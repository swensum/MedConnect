import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';

enum UserRole { patient, doctor }
const Color _kNeuBg = AppColors.paleBlue;

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  void _continue() {
    if (_selectedRole == null) return;

    context.push(AppRoutes.phoneEntry, extra: _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kNeuBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text('Welcome to MedConnect', style: AppTextStyles.h1),
              SizedBox(height: 8.h),
              Text(
                'Tell us who you are so we can set up the right experience.',
                style: AppTextStyles.bodySecondary,
              ),
              SizedBox(height: 32.h),

              _RoleCard(
                icon: Icons.person_outline,
                title: "I'm a Patient",
                subtitle:
                    'Find doctors, book consultations, and track health.',
                selected: _selectedRole == UserRole.patient,
                onTap: () => setState(() => _selectedRole = UserRole.patient),
              ),
              SizedBox(height: 20.h),
              _RoleCard(
                icon: Icons.medical_services_outlined,
                title: "I'm a Doctor",
                subtitle:
                    'Consult patients online and manage your clinic bookings.',
                selected: _selectedRole == UserRole.doctor,
                onTap: () => setState(() => _selectedRole = UserRole.doctor),
              ),

              const Spacer(),

              _NeumorphicButton(
                enabled: _selectedRole != null,
                label: 'Continue',
                onTap: _continue,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

List<BoxShadow> _neuShadows({
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
      color: const Color(0xFFA9BBCF).withOpacity(0.65),
      offset: darkOffset,
      blurRadius: blur,
      spreadRadius: 0.5,
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.9),
      offset: lightOffset,
      blurRadius: blur,
      spreadRadius: 0.5,
    ),
  ];
}

class _NeumorphicButton extends StatefulWidget {
  const _NeumorphicButton({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback onTap;

  @override
  State<_NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<_NeumorphicButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool down = _pressed && widget.enabled;
    final radius = 20.r;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          color: widget.enabled ? AppColors.navy : _kNeuBg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow:
              _neuShadows(distance: down ? 3 : 7, blur: down ? 6 : 16, inset: down),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: AppTextStyles.button.copyWith(
            fontSize: 15.sp,
            color: widget.enabled
                ? AppColors.white
                : AppColors.navy.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = 24.r;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: selected ? Color.lerp(_kNeuBg, AppColors.navy, 0.06) : _kNeuBg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: _neuShadows(
            distance: selected ? 4 : 7,
            blur: selected ? 8 : 16,
            inset: selected,
          ),
        ),
        child: Row(
          children: [
            _NeuIconBadge(icon: icon, active: selected),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySecondary.copyWith(
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            _NeuCheckDot(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _NeuIconBadge extends StatelessWidget {
  const _NeuIconBadge({required this.icon, required this.active});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: active ? Color.lerp(_kNeuBg, AppColors.navy, 0.06) : _kNeuBg,
        shape: BoxShape.circle,
        boxShadow: _neuShadows(distance: 4, blur: 8, inset: active),
      ),
      child: Icon(
        icon,
        size: 22.sp,
        color: active ? AppColors.navy : AppColors.navy.withOpacity(0.6),
      ),
    );
  }
}

class _NeuCheckDot extends StatelessWidget {
  const _NeuCheckDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: selected ? Color.lerp(_kNeuBg, AppColors.navy, 0.06) : _kNeuBg,
        shape: BoxShape.circle,
        boxShadow: _neuShadows(distance: 3, blur: 5, inset: true),
      ),
      child: selected
          ? Icon(Icons.check, size: 13.sp, color: AppColors.navy)
          : null,
    );
  }
}