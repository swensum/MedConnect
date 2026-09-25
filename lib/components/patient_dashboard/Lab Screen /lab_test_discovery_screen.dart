import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/lab_test_widgets.dart';
import 'package:med_connect/providers/lab_test_providers.dart';

class LabTestDiscoveryScreen extends ConsumerStatefulWidget {
  const LabTestDiscoveryScreen({super.key});

  @override
  ConsumerState<LabTestDiscoveryScreen> createState() =>
      _LabTestDiscoveryScreenState();
}

class _LabTestDiscoveryScreenState
    extends ConsumerState<LabTestDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(labTestSearchQueryProvider.notifier).state =
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
    final results = ref.watch(filteredLabTestsProvider);
    final allTests = ref.watch(labTestsProvider);
    final selectedCategory = ref.watch(labTestCategoryFilterProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final categories = [
      'All',
      ...{for (final t in allTests) t.category},
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
                      Text('Lab tests', style: AppTextStyles.h2),
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
                        Icon(
                          Icons.search_rounded,
                          size: 19.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: AppTextStyles.body,
                            decoration: InputDecoration(
                              hintText: 'Search tests, categories...',
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
                            child: Icon(
                              Icons.close_rounded,
                              size: 18.sp,
                              color: AppColors.textSecondary,
                            ),
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
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemBuilder: (context, i) {
                      final c = categories[i];
                      return NeuChip(
                        label: c,
                        selected: selectedCategory == c,
                        onTap: () =>
                            ref
                                    .read(
                                      labTestCategoryFilterProvider.notifier,
                                    )
                                    .state =
                                c,
                      );
                    },
                  ),
                ),
                SizedBox(height: 18.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    '${results.length} test${results.length == 1 ? '' : 's'} found',
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
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, i) {
                      final test = results[i];
                      return LabTestCard(
                        test: test,
                        onTap: () {
                          ref.read(selectedLabTestProvider.notifier).state =
                              test;
                          // TODO: navigate to lab test detail/booking screen.
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
            Icon(
              Icons.search_off_rounded,
              size: 40.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 12.h),
            Text(
              'No tests match your search',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
