import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';

/// Bottom-nav shell for the patient side of the app. Swaps between Home,
/// Appointments, and Profile tabs while keeping the nav bar persistent.
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
            const _PlaceholderTab(label: 'Profile'),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
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

/// -------- Mock data (swap for real models/Firestore once wired up) -----

class _SpecializationShortcut {
  const _SpecializationShortcut(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _shortcuts = [
  _SpecializationShortcut('General', Icons.medical_services_outlined),
  _SpecializationShortcut('Cardiology', Icons.favorite_border_rounded),
  _SpecializationShortcut('Dermatology', Icons.face_retouching_natural_rounded),
  _SpecializationShortcut('Pediatrics', Icons.child_care_rounded),
  _SpecializationShortcut('Dental', Icons.mood_outlined),
  _SpecializationShortcut('Neurology', Icons.psychology_outlined),
];

class _DoctorPreview {
  const _DoctorPreview({
    required this.name,
    required this.specialization,
    required this.experienceYears,
    required this.fee,
    required this.rating,
  });

  final String name;
  final String specialization;
  final int experienceYears;
  final int fee;
  final double rating;
}

const _topDoctors = [
  _DoctorPreview(
    name: 'Dr. Anita Sharma',
    specialization: 'Cardiologist',
    experienceYears: 12,
    fee: 800,
    rating: 4.8,
  ),
  _DoctorPreview(
    name: 'Dr. Bikash Thapa',
    specialization: 'General physician',
    experienceYears: 7,
    fee: 500,
    rating: 4.6,
  ),
  _DoctorPreview(
    name: 'Dr. Priya Koirala',
    specialization: 'Dermatologist',
    experienceYears: 9,
    fee: 700,
    rating: 4.9,
  ),
];

/// -------- Home tab -------------------------------------------------------

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
          _header(),
          SizedBox(height: 22.h),
          _searchBar(context),
          SizedBox(height: 28.h),
          _upcomingAppointmentCard(),
          SizedBox(height: 28.h),
          Text('Browse by specialization', style: AppTextStyles.h3),
          SizedBox(height: 14.h),
          _specializationRow(),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top doctors', style: AppTextStyles.h3),
              GestureDetector(
                onTap: () {
                  // TODO: navigate to full doctor discovery/search screen.
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
          ..._topDoctors.map(
            (d) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _DoctorCard(doctor: d),
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
              Text(
                'Hi, $patientName 👋',
                style: AppTextStyles.h2,
              ),
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
      onTap: () {
        // TODO: navigate to doctor search/discovery screen.
      },
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

  Widget _upcomingAppointmentCard() {
    // TODO: swap for real data — null/empty state shown when there's no
    // upcoming appointment.
    final hasUpcoming = _topDoctors.isNotEmpty;

    if (!hasUpcoming) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10, inset: true),
        ),
        child: Row(
          children: [
            Icon(Icons.event_available_outlined, size: 22.sp, color: AppColors.navy),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'No upcoming appointments — book one with a doctor near you.',
                style: AppTextStyles.bodySecondary,
              ),
            ),
          ],
        ),
      );
    }

    final doctor = _topDoctors.first;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: neuShadows(distance: 6, blur: 14),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: AppColors.white, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Today, 4:30 PM · ${doctor.specialization}',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.white, size: 20.sp),
        ],
      ),
    );
  }

  Widget _specializationRow() {
    return SizedBox(
      height: 84.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _shortcuts.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final s = _shortcuts[i];
          return GestureDetector(
            onTap: () {
              // TODO: navigate to doctor discovery pre-filtered by s.label.
            },
            child: Container(
              width: 72.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: kNeuBg,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: neuShadows(distance: 4, blur: 9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(s.icon, size: 22.sp, color: AppColors.navy),
                  SizedBox(height: 6.h),
                  Text(
                    s.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final _DoctorPreview doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to doctor detail/profile screen.
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(Icons.person_rounded, color: AppColors.navy, size: 26.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${doctor.specialization} · ${doctor.experienceYears} yrs exp',
                    style: AppTextStyles.caption,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber.shade700),
                      SizedBox(width: 3.w),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Rs. ${doctor.fee}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18.sp, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}