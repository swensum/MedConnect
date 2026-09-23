import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';

import 'package:med_connect/Theme/systemui.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';

class _CountryCode {
  const _CountryCode({
    required this.code,
    required this.name,
    required this.flag,
  });

  final String code;
  final String name;
  final String flag;
}

const List<_CountryCode> _countryCodes = [
  _CountryCode(code: '+977', name: 'Nepal', flag: '🇳🇵'),
  _CountryCode(code: '+91', name: 'India', flag: '🇮🇳'),
  _CountryCode(code: '+1', name: 'United States', flag: '🇺🇸'),
  _CountryCode(code: '+44', name: 'United Kingdom', flag: '🇬🇧'),
  _CountryCode(code: '+61', name: 'Australia', flag: '🇦🇺'),
  _CountryCode(code: '+971', name: 'United Arab Emirates', flag: '🇦🇪'),
  _CountryCode(code: '+966', name: 'Saudi Arabia', flag: '🇸🇦'),
  _CountryCode(code: '+974', name: 'Qatar', flag: '🇶🇦'),
  _CountryCode(code: '+65', name: 'Singapore', flag: '🇸🇬'),
  _CountryCode(code: '+60', name: 'Malaysia', flag: '🇲🇾'),
  _CountryCode(code: '+81', name: 'Japan', flag: '🇯🇵'),
  _CountryCode(code: '+82', name: 'South Korea', flag: '🇰🇷'),
  _CountryCode(code: '+86', name: 'China', flag: '🇨🇳'),
  _CountryCode(code: '+880', name: 'Bangladesh', flag: '🇧🇩'),
  _CountryCode(code: '+92', name: 'Pakistan', flag: '🇵🇰'),
  _CountryCode(code: '+49', name: 'Germany', flag: '🇩🇪'),
  _CountryCode(code: '+33', name: 'France', flag: '🇫🇷'),
  _CountryCode(code: '+39', name: 'Italy', flag: '🇮🇹'),
  _CountryCode(code: '+34', name: 'Spain', flag: '🇪🇸'),
  _CountryCode(code: '+7', name: 'Russia', flag: '🇷🇺'),
];

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key, required this.role});
  final UserRole role;

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String _fullPhoneNumber = '';
  bool _isValid = false;
  bool _isSending = false;

  Future<void> _sendOtp() async {
    if (!_isValid || _isSending) return;
    setState(() => _isSending = true);

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSending = false);

    context.push(AppRoutes.otpVerify, extra: (_fullPhoneNumber, widget.role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      appBar: AppBar(
        backgroundColor: kNeuBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        systemOverlayStyle: overlayFor(kNeuBg),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              RoleBadge(role: widget.role),
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
              NeuPillButton(
                enabled: _isValid && !_isSending,
                loading: _isSending,
                onTap: _sendOtp,
                label: 'Send OTP',
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

  Future<void> _openCountryPicker() async {
    HapticFeedback.selectionClick();
    final result = await showModalBottomSheet<_CountryCode>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CountryPickerSheet(selected: _selectedCode),
    );
    if (result != null) {
      setState(() => _selectedCode = result);
      _notifyParent();
    }
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
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: neuShadows(distance: 5, blur: 10, inset: true),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: _openCountryPicker,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedCode.flag, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    _selectedCode.code,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 1,
            height: 24.h,
            color: AppColors.mutedBlue.withValues(alpha: 0.6),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              decoration: bareInputDecoration('98XXXXXXXX'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.selected});
  final _CountryCode selected;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<_CountryCode> _filtered = _countryCodes;

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _countryCodes
          : _countryCodes
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(q) ||
                      c.code
                          .replaceAll('+', '')
                          .contains(q.replaceAll('+', '')),
                )
                .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: kNeuBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.mutedBlue.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      'Select country',
                      style: AppTextStyles.h1.copyWith(fontSize: 18.sp),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 46.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: neuShadows(distance: 2.5, blur: 5, inset: true),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 18.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: AppTextStyles.body,
                          decoration: bareInputDecoration(
                            'Search country or code',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No matches found',
                          style: AppTextStyles.bodySecondary,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final country = _filtered[index];
                          final isSelected =
                              country.code == widget.selected.code &&
                              country.name == widget.selected.name;
                          return InkWell(
                            borderRadius: BorderRadius.circular(14.r),
                            onTap: () => Navigator.of(context).pop(country),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.navy.withValues(alpha: 0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    country.flag,
                                    style: TextStyle(fontSize: 22.sp),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      country.name,
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    country.code,
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.check_rounded,
                                      size: 18.sp,
                                      color: AppColors.navy,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
