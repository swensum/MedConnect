import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';
import 'package:med_connect/models/lab_test_model.dart';

class LabTestCard extends StatelessWidget {
  const LabTestCard({super.key, required this.test, this.onTap});

  final LabTest test;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    shape: BoxShape.circle,
                    boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
                  ),
                  child: Icon(
                    Icons.biotech_outlined,
                    color: AppColors.navy,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${test.sampleType} · Report in ${test.reportTime}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Divider(
              height: 1,
              color: AppColors.mutedBlue.withValues(alpha: 0.4),
            ),
            SizedBox(height: 10.h),

            // ---- Lab/hospital info ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  size: 14.sp,
                  color: AppColors.navy,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.labName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        test.labAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: kTipTint,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Rs. ${test.price}',
                    style: AppTextStyles.caption.copyWith(
                      color: kTipColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
