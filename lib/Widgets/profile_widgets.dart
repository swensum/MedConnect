import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';
import 'package:med_connect/models/health_metric_model.dart';
import 'package:med_connect/models/patient_home_models.dart';

/// One stat pill in the profile header (Age / Blood type / City, etc.)
class ProfileStatChip extends StatelessWidget {
  const ProfileStatChip({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 3, blur: 8, inset: true),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 2.h),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

/// One tappable row in the profile menu (Payment methods, Help, etc.)
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.danger : AppColors.navy;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 3, blur: 8),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(icon, size: 17.sp, color: color),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5.sp,
                  color: isDestructive
                      ? AppColors.danger
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class HealthMetricsRow extends StatelessWidget {
  const HealthMetricsRow({super.key, required this.metrics});
  final List<HealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        itemCount: metrics.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final m = metrics[i];
          return Container(
            width: 76.w,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
            decoration: BoxDecoration(
              color: kNeuBg,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: neuShadows(distance: 4, blur: 9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(m.icon, size: 22.sp, color: m.accentColor),
                SizedBox(height: 8.h),
                Text(
                  m.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  m.value,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  final AppointmentPreview appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    shape: BoxShape.circle,
                    boxShadow: neuShadows(distance: 3, blur: 7, inset: true),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 26.sp,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Name / specialization (top) + date / time (bottom).
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          appointment.specialization,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                        SizedBox(
                          height: 8.h,
                        ), // gap between specialization and date/time
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 3.w),
                            Flexible(
                              child: Text(
                                '${appointment.dayNumber} '
                                '${appointment.monthYear.split(' ').first}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 10.5.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.access_time_rounded,
                              size: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 3.w),
                            Flexible(
                              child: Text(
                                appointment.time,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 10.5.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Status tag, pinned to the top-right corner.
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: kTipTint,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Confirmed',
                    style: AppTextStyles.caption.copyWith(
                      color: kTipColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular percentage ring — now also shows "Health score" inside the
/// ring, stacked below the percentage.
class _HealthScoreRing extends StatelessWidget {
  const _HealthScoreRing({required this.percent, required this.size});

  final int percent; // 0-100
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(percent: percent / 100),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Health Score',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white70,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.percent});
  final double percent; // 0.0 - 1.0

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - 7) / 2;

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const startAngle = -1.5708; // -90deg, start from top
    final sweepAngle = 6.28319 * percent; // 2*pi * percent

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.percent != percent;
}

class HealthStatusCard extends StatelessWidget {
  const HealthStatusCard({
    super.key,
    required this.healthScore,
    this.onViewDetail,
  });

  final int healthScore; // 0-100
  final VoidCallback? onViewDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w), // was 18.w
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
          // ---- Left: text + button ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your health overview',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp, // was 15.sp
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Stay updated with your health status',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                    fontSize: 12.sp, // was 11.5.sp
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 18.h), // was 14.h
                GestureDetector(
                  onTap: onViewDetail,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View detail',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 13.sp,
                          color: AppColors.navy,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),

          // ---- Right: ring (score + label now inside it) ----
          _HealthScoreRing(percent: healthScore, size: 105.w), // was 72.w
        ],
      ),
    );
  }
}

class HealthRecordsRow extends StatelessWidget {
  const HealthRecordsRow({
    super.key,
    required this.categories,
    this.onTapCategory,
  });

  final List<RecordCategory> categories;
  final void Function(RecordCategory category)? onTapCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final c = categories[i];
          return GestureDetector(
            onTap: () => onTapCategory?.call(c),
            child: Container(
              width: 115.w,
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: kNeuBg,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: neuShadows(distance: 4, blur: 9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: kNeuBg,
                      shape: BoxShape.circle,
                      boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
                    ),
                    child: Icon(c.icon, size: 20.sp, color: AppColors.navy),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    c.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '${c.count} file${c.count == 1 ? '' : 's'}',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
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

class BookConsultationBanner extends StatelessWidget {
  const BookConsultationBanner({super.key, this.onBookTap});

  final VoidCallback? onBookTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 14.h,
      ), // shorter than before
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            Color.lerp(AppColors.navy, Colors.black, 0.85)!,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: neuShadows(distance: 3, blur: 8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feeling unwell?',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Book a consultation with a doctor in minutes.',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                    fontSize: 11.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onBookTap,
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
                    'Book now',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 12.sp,
                    color: AppColors.navy,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
