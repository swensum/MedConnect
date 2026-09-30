import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';
import 'package:med_connect/models/patient_home_models.dart';

class AvailabilityToggle extends StatelessWidget {
  const AvailabilityToggle({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });

  final bool isOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isOnline),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: neuShadows(distance: 3, blur: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9.w,
              height: 9.w,
              decoration: BoxDecoration(
                color: isOnline ? kTipColor : AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              isOnline ? 'Accepting bookings' : 'Not accepting bookings',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: isOnline ? kTipColor : AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              isOnline ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
              size: 22.sp,
              color: isOnline ? kTipColor : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// One quick-stat tile on the doctor's home tab (Today / This week /
/// Total patients, etc.)
class DoctorStatCard extends StatelessWidget {
  const DoctorStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: neuShadows(distance: 3, blur: 8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18.sp, color: AppColors.navy),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800, fontSize: 16.sp),
            ),
            SizedBox(height: 2.h),
            Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class PatientAppointmentCard extends StatelessWidget {
  const PatientAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  final AppointmentPreview appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isVideo = appointment.consultationMode == 'Video call';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: neuShadows(distance: 4, blur: 9),
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 3, blur: 7, inset: true),
              ),
              child: Icon(Icons.person_rounded, size: 21.sp, color: AppColors.navy),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5.sp),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        isVideo ? Icons.videocam_outlined : Icons.local_hospital_outlined,
                        size: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        appointment.consultationMode ?? '',
                        style: AppTextStyles.caption.copyWith(fontSize: 10.5.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  appointment.time,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${appointment.dayNumber} ${appointment.monthYear.split(' ').first}',
                  style: AppTextStyles.caption.copyWith(fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/// Navy-to-black gradient card summarizing this week's earnings — mirrors
/// HealthStatusCard's styling on the patient side for visual consistency.
class WeeklyEarningsCard extends StatelessWidget {
  const WeeklyEarningsCard({
    super.key,
    required this.amount,
    required this.appointmentCount,
    this.onViewReport,
  });

  final int amount;
  final int appointmentCount;
  final VoidCallback? onViewReport;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            Color.lerp(AppColors.navy, Colors.black, 0.85)!,
          ],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: neuShadows(distance: 3, blur: 8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This week\'s earnings',
                  style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 15.sp),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Rs. $amount',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 26.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'From $appointmentCount appointment${appointmentCount == 1 ? '' : 's'}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                    fontSize: 11.5.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: onViewReport,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View report',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5.sp,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Icon(Icons.arrow_forward_rounded, size: 13.sp, color: AppColors.navy),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.trending_up_rounded,
            size: 56.sp,
            color: Colors.white.withValues(alpha: 0.18),
          ),
        ],
      ),
    );
  }
}