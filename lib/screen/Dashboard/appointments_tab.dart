import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/appointment_providers.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/appointment_widgets.dart';

class AppointmentsTab extends ConsumerStatefulWidget {
  const AppointmentsTab({super.key});

  @override
  ConsumerState<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends ConsumerState<AppointmentsTab> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(appointmentsProvider);
    final upcoming = all.where((a) => !a.isPast).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final past = all.where((a) => a.isPast).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final shown = _showUpcoming ? upcoming : past;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
            child: Text('Appointments', style: AppTextStyles.h1),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _toggle(),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: shown.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
                    itemCount: shown.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, i) {
                      final appt = shown[i];
                      return AppointmentListCard(
                        appointment: appt,
                        onCancel: _showUpcoming
                            ? () => ref
                                .read(appointmentsProvider.notifier)
                                .cancel(appt.id)
                            : null,
                        onBookAgain: !_showUpcoming
                            ? () {
                                // TODO: navigate to that doctor's profile
                                // to start a new booking.
                              }
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _toggle() {
    Widget tab(String label, bool selected, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : kNeuBg,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: neuShadows(
                distance: selected ? 2 : 3,
                blur: selected ? 5 : 7,
                inset: selected,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: selected ? Colors.white : AppColors.navy,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: neuShadows(distance: 3, blur: 7, inset: true),
      ),
      child: Row(
        children: [
          tab('Upcoming', _showUpcoming, () => setState(() => _showUpcoming = true)),
          SizedBox(width: 6.w),
          tab('Past', !_showUpcoming, () => setState(() => _showUpcoming = false)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined, size: 40.sp, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              _showUpcoming
                  ? 'No upcoming appointments yet.'
                  : 'No past appointments.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}