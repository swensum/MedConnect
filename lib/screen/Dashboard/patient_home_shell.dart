import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';

import 'package:med_connect/models/patient_home_models.dart';

class PatientHomeShell extends StatefulWidget {
  const PatientHomeShell({super.key, required this.patientName});

  final String patientName;

  @override
  State<PatientHomeShell> createState() => _PatientHomeShellState();
}

class _PatientHomeShellState extends State<PatientHomeShell> {
  int _tabIndex = 0;

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
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Messages',
    ),
    NeuBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _tabIndex,
          children: [
            _PatientHomeTab(patientName: widget.patientName),
            const _PlaceholderTab(label: 'Appointments'),
            const _PlaceholderTab(label: 'Messages'),
            const _PlaceholderTab(label: 'Profile'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom * 0.1, // half the usual inset
        ),
        child: NeuBottomNavBar(
          items: _items,
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
        ),
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

class _PatientHomeTab extends StatelessWidget {
  const _PatientHomeTab({required this.patientName});

  final String patientName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationRow(
            // TODO: swap for the user's real detected/selected location.
            location: 'Biratnagar, Koshi',
            onTap: () {
              // TODO: open location picker, or re-request GPS location.
            },
          ),
          SizedBox(height: 16.h),
          _header(),
          SizedBox(height: 22.h),
          _searchBar(context),
          SizedBox(height: 28.h),
          TodayAppointmentCard(
            appointment: todaysAppointment,
            onTap: () {
              // TODO: navigate to appointment detail screen.
            },
          ),
          SizedBox(height: 28.h),
          Text('What do you need today?', style: AppTextStyles.h3),
          SizedBox(height: 14.h),
          QuickActionRow(
            actions: quickActions,
            onTapAction: (a) {
              if (a.isEmergency) {
                // TODO: launch emergency call / ambulance flow.
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
                onTap: () {
                  // TODO: navigate to full hospitals/clinics list screen.
                },
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
          HospitalRow(
            hospitals: nearbyHospitals,
            onTapHospital: (h) {
              // TODO: navigate to hospital detail screen.
            },
          ),
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
                onTap: () {
                  // TODO: navigate to full exercise plan screen.
                },
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
              child: ExerciseListItem(
                exercise: e,
                onTap: () {
                  // TODO: navigate to exercise detail screen.
                },
              ),
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
          onTap: () {
            // TODO: navigate to notifications screen.
          },
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
            Icon(Icons.search_rounded, size: 19.sp, color: AppColors.textSecondary),
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