import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';
import 'package:med_connect/providers/doctor_providers.dart';

class DoctorDiscoveryScreen extends ConsumerStatefulWidget {
  const DoctorDiscoveryScreen({super.key, this.initialSpecialization});
  final String? initialSpecialization;

  @override
  ConsumerState<DoctorDiscoveryScreen> createState() =>
      _DoctorDiscoveryScreenState();
}

class _DoctorDiscoveryScreenState
    extends ConsumerState<DoctorDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Seed the filter provider from the quick-action tile that launched
    // this screen (e.g. tapping "Doctor" vs a specific specialization).
    if (widget.initialSpecialization != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(specializationFilterProvider.notifier).state =
            widget.initialSpecialization!;
      });
    }
    _searchController.addListener(() {
      ref.read(doctorSearchQueryProvider.notifier).state =
          _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(filteredDoctorsProvider);
    final allSpecializations = ref.watch(doctorsProvider);
    final selectedSpecialization = ref.watch(specializationFilterProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final filters = [
      'All',
      ...{for (final d in allSpecializations) d.specialization},
    ];

    return Scaffold(
      backgroundColor: kNeuBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: kNeuBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
              boxShadow: neuShadows(distance: 4, blur: 10),
            ),
            padding: EdgeInsets.only(bottom: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0),
                  child: Row(
                    children: [
                      NeuCircleButton(
                        size: 36,
                        icon: Icons.arrow_back_rounded,
                        onTap: () => context.pop(),
                      ),
                      SizedBox(width: 14.w),
                      Text('Find a doctor', style: AppTextStyles.h2),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: NeuInsetSurface(
                    height: 54.h,
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            size: 19.sp, color: AppColors.textSecondary),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: AppTextStyles.body,
                            decoration: InputDecoration(
                              hintText: 'Search doctors, specialties...',
                              hintStyle: AppTextStyles.bodySecondary,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () => _searchController.clear(),
                            child: Icon(Icons.close_rounded,
                                size: 18.sp, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: filters.length,
                    separatorBuilder: (_, _) => SizedBox(width: 10.w),
                    itemBuilder: (context, i) {
                      final f = filters[i];
                      return NeuChip(
                        label: f,
                        selected: selectedSpecialization == f,
                        onTap: () => ref
                            .read(specializationFilterProvider.notifier)
                            .state = f,
                      );
                    },
                  ),
                ),
                SizedBox(height: 18.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    '${results.length} doctor${results.length == 1 ? '' : 's'} found',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: results.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      24.w,
                      14.h,
                      24.w,
                      24.h + bottomInset,
                    ),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, i) {
                      final doctor = results[i];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          ref.read(selectedDoctorProvider.notifier).state =
                              doctor;
                          context.push(AppRoutes.doctorProfile);
                        },
                      );
                    },
                  ),
          ),
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
            Icon(Icons.search_off_rounded,
                size: 40.sp, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              'No doctors match your search',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}