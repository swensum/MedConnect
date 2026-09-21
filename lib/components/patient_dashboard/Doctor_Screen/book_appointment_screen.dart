import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/booking_widgets.dart';
import 'package:med_connect/Widgets/doctor_profile_widgets.dart'; // NEW — for WorkplaceCard

import 'package:med_connect/models/booking_models.dart';
import 'package:med_connect/providers/booking_providers.dart';
import 'package:med_connect/providers/doctor_providers.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ref.watch(selectedDoctorProvider);
    final draft = ref.watch(bookingDraftProvider);
    final notifier = ref.read(bookingDraftProvider.notifier);

    if (doctor == null) {
      return Scaffold(
        backgroundColor: kNeuBg,
        body: SafeArea(
          child: Center(
            child: Text(
              'No doctor selected.',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ),
      );
    }

    final slotGroups = (draft.date != null && draft.consultationMode != null)
        ? mockSlotsFor(draft.date!, draft.consultationMode!)
        : <String, List<TimeSlot>>{};

    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
              child: Row(
                children: [
                  NeuCircleButton(
                    size: 36,
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                  ),
                  SizedBox(width: 14.w),
                  Text('Book appointment', style: AppTextStyles.h2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
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
                            size: 22.sp,
                            color: AppColors.navy,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                doctor.specialization,
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26.h),

                    if (doctor.consultationModes.length > 1) ...[
                      Text('Consultation mode', style: AppTextStyles.h3),
                      SizedBox(height: 12.h),
                      Row(
                        children: doctor.consultationModes.map((m) {
                          final selected = draft.consultationMode == m;
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: NeuChip(
                              label: m,
                              selected: selected,
                              onTap: () => notifier.selectMode(m),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 26.h),
                    ] else if (doctor.consultationModes.isNotEmpty) ...[
                      Builder(
                        builder: (_) {
                          if (draft.consultationMode == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              notifier.selectMode(
                                doctor.consultationModes.first,
                              );
                            });
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],

                    // ── NEW BLOCK — only shows when "In-clinic" is picked ──
                    if (draft.consultationMode == 'In-clinic' &&
                        doctor.workplaceName != null) ...[
                      Text('Visit location', style: AppTextStyles.h3),
                      SizedBox(height: 12.h),
                      WorkplaceCard(
                        name: doctor.workplaceName!,
                        address: doctor.workplaceAddress ?? '',
                      ),
                      SizedBox(height: 14.h),
                      const PriorityNoteCard(),
                      SizedBox(height: 26.h),
                    ],
                    // ── END NEW BLOCK ──

                    Text('Select date', style: AppTextStyles.h3),
                    SizedBox(height: 12.h),
                    DateStrip(
                      selectedDate: draft.date,
                      onSelect: notifier.selectDate,
                    ),
                    SizedBox(height: 22.h),

                    // ── CHANGED — "Select time" now only shows once a
                    // consultation mode has been picked, since slots
                    // depend on which mode's hours to display. ──
                    if (draft.consultationMode != null) ...[
                      Text('Select time', style: AppTextStyles.h3),
                      SizedBox(height: 14.h),
                      ...slotGroups.entries.map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: SlotSection(
                            label: entry.key,
                            slots: entry.value,
                            selectedSlot: draft.slot,
                            onSelect: notifier.selectSlot,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                    // ── END CHANGED ──

                    Text(
                      'Note for the doctor (optional)',
                      style: AppTextStyles.h3,
                    ),
                    SizedBox(height: 12.h),
                    NeuInsetSurface(
                      padding: EdgeInsets.all(14.w),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 3,
                        onChanged: notifier.setNote,
                        style: AppTextStyles.body,
                        decoration: bareInputDecoration(
                          'e.g. Reason for visit, symptoms...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Consultation fee',
                        style: AppTextStyles.bodySecondary,
                      ),
                      Text(
                        'Rs. ${doctor.fee}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  NeuPillButton(
                    enabled: draft.isComplete,
                    onTap: () => context.push(AppRoutes.bookingConfirm),
                    label: 'Confirm booking',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}