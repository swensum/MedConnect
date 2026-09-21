import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';
import 'package:med_connect/models/booking_models.dart';

const List<String> _weekdayShort = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

class DateStrip extends StatelessWidget {
  const DateStrip({
    super.key,
    required this.selectedDate,
    required this.onSelect,
    this.dayCount = 14,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelect;
  final int dayCount;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(
      dayCount,
      (i) => DateTime(today.year, today.month, today.day + i),
    );

    return SizedBox(
      height: 76.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        itemCount: days.length,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, i) {
          final day = days[i];
          final selected = selectedDate != null && _isSameDay(day, selectedDate!);
          return GestureDetector(
            onTap: () => onSelect(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 54.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: selected ? AppColors.navy : kNeuBg,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: neuShadows(
                  distance: selected ? 2 : 4,
                  blur: selected ? 5 : 9,
                  inset: selected,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayShort[day.weekday - 1],
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${day.day}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: selected ? AppColors.white : AppColors.navy,
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

/// One labeled section (Morning/Afternoon/Evening) of time-slot chips.
class SlotSection extends StatelessWidget {
  const SlotSection({
    super.key,
    required this.label,
    required this.slots,
    required this.selectedSlot,
    required this.onSelect,
  });

  final String label;
  final List<TimeSlot> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: slots.map((s) {
            final selected = selectedSlot == s.time;
            return GestureDetector(
              onTap: s.isAvailable ? () => onSelect(s.time) : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.navy
                      : s.isAvailable
                          ? kNeuBg
                          : kNeuBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: s.isAvailable
                      ? neuShadows(
                          distance: selected ? 2 : 3,
                          blur: selected ? 5 : 7,
                          inset: selected,
                        )
                      : null,
                ),
                child: Text(
                  s.time,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5.sp,
                    color: selected
                        ? AppColors.white
                        : s.isAvailable
                            ? AppColors.navy
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                    decoration: s.isAvailable ? null : TextDecoration.lineThrough,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
class PriorityNoteCard extends StatelessWidget {
  const PriorityNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: kTipTint,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.bolt_rounded, size: 17.sp, color: kTipColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Booking online reserves your spot — you\'ll get priority '
              'check-in ahead of walk-in patients.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}