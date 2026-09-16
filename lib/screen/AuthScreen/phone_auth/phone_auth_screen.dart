import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';

const List<_CountryCode> _countryCodes = [
  _CountryCode(code: '977', label: 'Nepal'),
  _CountryCode(code: '+91', label: 'India'),
  _CountryCode(code: '+1', label: 'USA'),
  _CountryCode(code: '+44', label: 'UK'),
];

class _CountryCode {
  const _CountryCode({required this.code, required this.label});
  final String code;
  final String label;
}

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key, required this.role});
  final UserRole role;

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String _fullPhoneNumber = '';
  bool _isValid = false;

  void _sendOtp() {
    if (!_isValid) return;
    context.push(AppRoutes.otpVerify, extra: (_fullPhoneNumber, widget.role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              _RoleBadge(role: widget.role),
              SizedBox(height: 24.h),
              Text('Enter your phone number', style: AppTextStyles.h1),
              SizedBox(height: 8.h),
              Text(
                "We'll send a one-time code to verify it's you.",
                style: AppTextStyles.bodySecondary,
              ),
              SizedBox(height: 32.h),
              _PhoneInputField(
                onChanged: (fullNumber, isValid) {
                  setState(() {
                    _fullPhoneNumber = fullNumber;
                    _isValid = isValid;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _isValid ? _sendOtp : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: AppColors.mutedBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Send OTP'),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInputField extends StatefulWidget {
  const _PhoneInputField({required this.onChanged});

  final void Function(String fullNumber, bool isValid) onChanged;

  @override
  State<_PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<_PhoneInputField> {
  final TextEditingController _controller = TextEditingController();
  _CountryCode _selectedCode = _countryCodes.first;

  void _notifyParent() {
    final digits = _controller.text.trim();
    final isValid = digits.length >= 7 && digits.length <= 12;
    widget.onChanged('${_selectedCode.code}$digits', isValid);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_notifyParent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 47.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.mutedBlue),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<_CountryCode>(
              value: _selectedCode,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 18.sp,
                color: AppColors.textSecondary,
              ),
              items: _countryCodes.map((c) {
                return DropdownMenuItem(
                  value: c,
                child: Text(
  c.code,
  style: AppTextStyles.body.copyWith(
    fontWeight: FontWeight.w600,
  ),
),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCode = value);
                _notifyParent();
              },
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            decoration: const InputDecoration(hintText: '98XXXXXXXX'),
          ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final UserRole role;
  @override
  Widget build(BuildContext context) {
    final label = role == UserRole.patient ? 'Patient' : 'Doctor';
    final icon = role == UserRole.patient
        ? Icons.person_outline
        : Icons.medical_services_outlined;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.paleBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.navy),
          SizedBox(width: 6.w),
          Text(
            'Signing up as $label',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
