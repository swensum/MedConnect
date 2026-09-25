import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/appointment_providers.dart';
import 'package:med_connect/Providers/nav_providers.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';

import 'package:med_connect/models/patient_home_models.dart';
import 'package:med_connect/screen/Dashboard/appointments_tab.dart';
import 'package:med_connect/screen/Dashboard/profile_tab.dart';

class PatientHomeShell extends ConsumerWidget {
  const PatientHomeShell({super.key, required this.patientName});

  final String patientName;

  static const _items = [
    NeuBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NeuBottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_month_rounded,
      label: 'Appointments',
    ),
    NeuBottomNavItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
      label: 'Records',
    ),
    NeuBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(patientTabIndexProvider);
    return Scaffold(
      backgroundColor: kNeuBg,
      extendBody: true,

      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: tabIndex,
          children: [
            _PatientHomeTab(patientName: patientName),
            const AppointmentsTab(),
            const _PlaceholderTab(label: 'Records'),
            const ProfileTab(),
          ],
        ),
      ),

      bottomNavigationBar: NeuBottomNavBar(
        items: _items,
        currentIndex: tabIndex,
        onTap: (i) {
          ref.read(patientTabIndexProvider.notifier).state = i;
        },
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label — coming soon', style: AppTextStyles.bodySecondary),
    );
  }
}

class _PatientHomeTab extends ConsumerWidget {
  const _PatientHomeTab({required this.patientName});

  final String patientName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(nextAppointmentProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationRow(location: 'Biratnagar, Koshi', onTap: () {}),
          SizedBox(height: 16.h),
          _header(),
          SizedBox(height: 22.h),
          _searchBar(context),
          SizedBox(height: 28.h),
          TodayAppointmentCard(appointment: appointment, onTap: () {}),
          SizedBox(height: 28.h),
          Text('What do you need today?', style: AppTextStyles.h3),
          SizedBox(height: 14.h),
          QuickActionRow(
            actions: quickActions,
            onTapAction: (a) {
              if (a.isEmergency) {
                return;
              }
              if (a.label == 'Doctor') {
                context.push(AppRoutes.doctorDiscovery);
                return;
              }
              if (a.label == 'Lab tests') {
                context.push(AppRoutes.labTestDiscovery);
                return;
              }

              context.push(AppRoutes.doctorDiscovery, extra: a.label);
            },
          ),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hospitals near you', style: AppTextStyles.h3),
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
          SizedBox(height: 14.h),
          HospitalRow(hospitals: nearbyHospitals, onTapHospital: (h) {}),
          SizedBox(height: 28.h),
          Text("Today's health tip", style: AppTextStyles.h3),
          SizedBox(height: 14.h),
          HealthTipCard(tip: todaysHealthTip),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Exercises from your doctor', style: AppTextStyles.h3),
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
          SizedBox(height: 14.h),
          ...recommendedExercises.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ExerciseListItem(exercise: e, onTap: () {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, $patientName 👋', style: AppTextStyles.h2),
              SizedBox(height: 2.h),
              Text(
                'How are you feeling today?',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        NeuCircleButton(
          size: 46,
          icon: Icons.notifications_none_rounded,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.doctorDiscovery),
      child: NeuInsetSurface(
        height: 54.h,
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 19.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'Search doctors, specialties...',
                style: AppTextStyles.bodySecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
