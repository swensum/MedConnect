import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/doctor_account_providers.dart';
import 'package:med_connect/Providers/doctor_dashboard_providers.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/doctor_dashboard_widgets.dart';

class DoctorHomeTab extends ConsumerWidget {
  const DoctorHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(doctorAccountProvider);
    final isOnline = ref.watch(doctorAvailabilityProvider);
    final todayAppointments = ref.watch(doctorTodayAppointmentsProvider);
    final upcomingAppointments = ref.watch(doctorUpcomingAppointmentsProvider);
    final nextAppointment = ref.watch(doctorNextAppointmentProvider);
    final weeklyEarnings = ref.watch(doctorWeeklyEarningsProvider);
    final totalPatients = ref.watch(doctorTotalPatientsProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Dr. ${doctor?.name.split(' ').last ?? ''} 👋',
                      style: AppTextStyles.h2,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      doctor?.specialization ?? '',
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
          ),
          SizedBox(height: 16.h),

          AvailabilityToggle(
            isOnline: isOnline,
            onChanged: (v) => ref.read(doctorAvailabilityProvider.notifier).state = v,
          ),
          SizedBox(height: 20.h),

          // ---- Navy earnings banner ----
          WeeklyEarningsCard(
            amount: weeklyEarnings,
            appointmentCount: upcomingAppointments.length,
            onViewReport: () {
              // TODO: navigate to a full earnings/reports screen.
            },
          ),
          SizedBox(height: 20.h),

          Row(
            children: [
              DoctorStatCard(
                icon: Icons.today_rounded,
                label: 'Today',
                value: '${todayAppointments.length}',
              ),
              SizedBox(width: 10.w),
              DoctorStatCard(
                icon: Icons.event_available_rounded,
                label: 'Upcoming',
                value: '${upcomingAppointments.length}',
              ),
              SizedBox(width: 10.w),
              DoctorStatCard(
                icon: Icons.people_alt_outlined,
                label: 'Patients',
                value: '$totalPatients',
              ),
            ],
          ),
          SizedBox(height: 26.h),

          Text('Next appointment', style: AppTextStyles.h3),
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
              : PatientAppointmentCard(appointment: nextAppointment, onTap: () {}),

          if (upcomingAppointments.length > 1) ...[
            SizedBox(height: 26.h),
            Text('Rest of today', style: AppTextStyles.h3),
            SizedBox(height: 12.h),
            ...upcomingAppointments.skip(1).take(5).map(
                  (a) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: PatientAppointmentCard(appointment: a, onTap: () {}),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}