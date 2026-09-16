import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';

enum UserRole { patient, doctor }

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
      backgroundColor: AppColors.white,
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
                    'Find doctors, book consultations, and track your health.',
                selected: _selectedRole == UserRole.patient,
                onTap: () => setState(() => _selectedRole = UserRole.patient),
              ),
              SizedBox(height: 16.h),
              _RoleCard(
                icon: Icons.medical_services_outlined,
                title: "I'm a Doctor",
                subtitle:
                    'Consult patients online and manage your clinic bookings.',
                selected: _selectedRole == UserRole.doctor,
                onTap: () => setState(() => _selectedRole = UserRole.doctor),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _selectedRole == null ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: AppColors.mutedBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              SizedBox(height: 24.h),
            ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.paleBlue : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.navy : AppColors.mutedBlue,
            width: selected ? 1.6 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: selected ? AppColors.navy : AppColors.paleBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color: selected ? AppColors.white : AppColors.navy,
              ),
            ),
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
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.navy : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.navy : AppColors.mutedBlue,
                  width: 1.6,
                ),
              ),
              child: selected
                  ? Icon(Icons.check, size: 13.sp, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}