import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/nav_providers.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';

import 'package:med_connect/Widgets/profile_widgets.dart';
import 'package:med_connect/models/health_metric_model.dart';
import 'package:med_connect/Providers/appointment_providers.dart';
import 'package:med_connect/providers/patient_profile_providers.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(patientProfileProvider);
    final nextAppointment = ref.watch(nextAppointmentProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: AppTextStyles.h1),
          SizedBox(height: 18.h),

          // ---- Header card ----
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: kNeuBg,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: neuShadows(distance: 4, blur: 10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        color: kNeuBg,
                        shape: BoxShape.circle,
                        boxShadow: neuShadows(
                          distance: 3,
                          blur: 8,
                          inset: true,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 30.sp,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.name ?? 'Complete your profile',
                            style: AppTextStyles.h3,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            profile?.phone ?? '',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                    ),
                    NeuCircleButton(
                      size: 38,
                      icon: Icons.edit_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
                if (profile != null) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      ProfileStatChip(label: 'Age', value: '${profile.age}'),
                      SizedBox(width: 10.w),
                      ProfileStatChip(
                        label: 'Blood type',
                        value: profile.bloodType ?? '—',
                      ),
                      SizedBox(width: 10.w),
                      ProfileStatChip(label: 'City', value: profile.city),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (profile == null) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: kNeuBg,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: neuShadows(distance: 3, blur: 8, inset: true),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Finish setting up your profile to see your health details here.',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16.h),
          HealthStatusCard(healthScore: 78, onViewDetail: () {}),
          SizedBox(height: 26.h),

          HealthMetricsRow(metrics: mockHealthMetrics),

          SizedBox(height: 26.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upcoming appointment', style: AppTextStyles.h3),
              if (nextAppointment != null)
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'See all',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          nextAppointment == null
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: neuShadows(distance: 4, blur: 10, inset: true),
                  ),
                  child: Text(
                    'No upcoming appointments.',
                    style: AppTextStyles.bodySecondary,
                  ),
                )
              : UpcomingAppointmentCard(appointment: nextAppointment),
          SizedBox(height: 20.h),
          BookConsultationBanner(
            onBookTap: () => context.push(AppRoutes.doctorDiscovery),
          ),
          SizedBox(height: 26.h),
          Text('Health records', style: AppTextStyles.h3),
          SizedBox(height: 12.h),
          HealthRecordsRow(
            categories: recordCategories,
            onTapCategory: (category) {
              ref.read(patientTabIndexProvider.notifier).state = 2;
            },
          ),

          SizedBox(height: 26.h),
          Text('Account', style: AppTextStyles.h3),
          SizedBox(height: 12.h),
          ProfileMenuTile(
            icon: Icons.payments_outlined,
            label: 'Payment methods',
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy & security',
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & support',
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Icons.info_outline_rounded,
            label: 'About MedConnect',
            onTap: () {},
          ),
          SizedBox(height: 12.h),
          ProfileMenuTile(
            icon: Icons.logout_rounded,
            label: 'Log out',
            isDestructive: true,
            onTap: () {
              // TODO: sign out via auth, clear providers, navigate to
              // AppRoutes.roleSelection or splash.
            },
          ),
        ],
      ),
    );
  }
}
