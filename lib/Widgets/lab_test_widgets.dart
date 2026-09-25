import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
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
        child: Row(
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
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${test.sampleType} · Report in ${test.reportTime}',
                    style: AppTextStyles.caption,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        'Rs. ${test.price}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (test.homeSampleAvailable) ...[
                        SizedBox(width: 10.w),
                        Icon(Icons.home_outlined, size: 12.sp, color: AppColors.textSecondary),
                        SizedBox(width: 3.w),
                        Text(
                          'Home sample',
                          style: AppTextStyles.caption.copyWith(fontSize: 10.5.sp),
                        ),
                      ],
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