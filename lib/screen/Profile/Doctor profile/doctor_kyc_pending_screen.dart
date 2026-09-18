import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';

enum DoctorKycStatus { pending, rejected, approved }

class DoctorKycPendingScreen extends StatefulWidget {
  const DoctorKycPendingScreen({
    super.key,
    this.status = DoctorKycStatus.pending,
    this.rejectionReason,
    this.onResubmit,
    this.onContinue,
  });

  final DoctorKycStatus status;

  /// Shown only when [status] is rejected — the admin's note on what to fix.
  final String? rejectionReason;

  /// Called when the doctor taps "Edit & resubmit" on a rejected KYC.
  /// Typically pops back to the KYC form.
  final VoidCallback? onResubmit;

  /// Called when the doctor taps "Go to dashboard" once approved.
  final VoidCallback? onContinue;

  @override
  State<DoctorKycPendingScreen> createState() =>
      _DoctorKycPendingScreenState();
}

class _DoctorKycPendingScreenState extends State<DoctorKycPendingScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshStatus() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    // TODO: re-fetch doctor_profiles.verified_status from Firestore and
    // update the status shown here (e.g. via a provider/bloc refresh).
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      _statusHeader(),
                      SizedBox(height: 36.h),
                      if (widget.status != DoctorKycStatus.rejected)
                        _StatusTimeline(status: widget.status),
                      if (widget.status == DoctorKycStatus.rejected)
                        _rejectionNote(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8.h, 0, 24.h),
                child: _bottomAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusHeader() {
    switch (widget.status) {
      case DoctorKycStatus.pending:
        return Column(
          children: [
            const NeuPulseIcon(icon: Icons.hourglass_top_rounded, flip: true,),
            SizedBox(height: 20.h),
            Text('Verification in progress', style: AppTextStyles.h2),
            SizedBox(height: 8.h),
            Text(
              'Our team is reviewing your documents. This usually takes '
              '24–48 hours — we\'ll notify you as soon as it\'s done.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        );
      case DoctorKycStatus.rejected:
        return Column(
          children: [
            NeuPulseIcon(
              icon: Icons.error_outline_rounded,
              color: AppColors.danger,
            ),
            SizedBox(height: 20.h),
            Text('Verification unsuccessful', style: AppTextStyles.h2),
            SizedBox(height: 8.h),
            Text(
              'We couldn\'t verify your documents. Please review the note '
              'below and resubmit.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        );
      case DoctorKycStatus.approved:
        return Column(
          children: [
            const NeuSuccessCheck(),
            SizedBox(height: 20.h),
            Text('You\'re verified!', style: AppTextStyles.h2),
            SizedBox(height: 8.h),
            Text(
              'Your profile is live — patients can now find and book you.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        );
    }
  }

  Widget _rejectionNote() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: neuShadows(distance: 4, blur: 9, inset: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 15.sp, color: AppColors.danger),
              SizedBox(width: 6.w),
              Text(
                'Reason',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            widget.rejectionReason ??
                'One or more documents were unclear or didn\'t match the '
                    'details you entered. Please upload clearer copies.',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _bottomAction() {
    switch (widget.status) {
      case DoctorKycStatus.pending:
        return NeuPillButton(
          enabled: !_isRefreshing,
          loading: _isRefreshing,
          onTap: _refreshStatus,
          label: 'Refresh status',
          icon: Icons.refresh_rounded,
        );
      case DoctorKycStatus.rejected:
        return NeuPillButton(
          enabled: true,
          onTap: widget.onResubmit ?? () => Navigator.of(context).pop(),
          label: 'Edit & resubmit',
        );
      case DoctorKycStatus.approved:
        return NeuPillButton(
          enabled: true,
          onTap: widget.onContinue ?? () {},
          label: 'Go to dashboard',
        );
    }
  }
}

/// Three-step progress indicator: Submitted -> Under review -> Approved.
/// Each step is either done (filled navy + check), current (pulsing ring),
/// or upcoming (muted outline).
class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.status});

  final DoctorKycStatus status;

  int get _activeStep {
    switch (status) {
      case DoctorKycStatus.pending:
        return 1; // "Under review" is current
      case DoctorKycStatus.approved:
        return 2; // "Approved" is current/done
      case DoctorKycStatus.rejected:
        return 1;
    }
  }

  static const _labels = ['Submitted', 'Under review', 'Approved'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStepDone = (i - 1) ~/ 2 < _activeStep;
          return Expanded(
            child: Container(
              height: 2.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: leftStepDone
                  ? AppColors.navy
                  : AppColors.mutedBlue.withValues(alpha: 0.5),
            ),
          );
        }
        final step = i ~/ 2;
        final isDone = step < _activeStep;
        final isCurrent = step == _activeStep;
        return Column(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: isDone || isCurrent ? AppColors.navy : kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(
                  distance: 2,
                  blur: 5,
                  inset: !(isDone || isCurrent),
                ),
              ),
              child: isDone
                  ? Icon(Icons.check_rounded,
                      size: 15.sp, color: AppColors.white)
                  : isCurrent
                      ? Padding(
                          padding: EdgeInsets.all(8.w),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(AppColors.white),
                          ),
                        )
                      : null,
            ),
            SizedBox(height: 6.h),
            Text(
              _labels[step],
              style: AppTextStyles.caption.copyWith(
                fontWeight:
                    isCurrent ? FontWeight.w700 : FontWeight.w500,
                color:
                    isDone || isCurrent ? AppColors.navy : AppColors.textSecondary,
              ),
            ),
          ],
        );
      }),
    );
  }
}