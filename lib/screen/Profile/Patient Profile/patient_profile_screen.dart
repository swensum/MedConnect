import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';

import 'package:med_connect/Theme/systemui.dart';
import 'package:med_connect/Theme/theme.dart';

const List<String> _genders = ['Male', 'Female', 'Other'];
const List<String> _bloodTypes = [
  'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
];

class PatientProfileSetupScreen extends StatefulWidget {
  const PatientProfileSetupScreen({super.key, required this.phone});

  final String phone;

  @override
  State<PatientProfileSetupScreen> createState() =>
      _PatientProfileSetupScreenState();
}

class _PatientProfileSetupScreenState extends State<PatientProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _dob;
  String? _gender;
  String? _bloodType;
  bool _isSaving = false;

  bool get _isValid =>
      _nameController.text.trim().length >= 2 &&
      _dob != null &&
      _gender != null &&
      _cityController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final c in [_nameController, _cityController]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.navy,
            onPrimary: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!_isValid || _isSaving) return;
    setState(() => _isSaving = true);

    // TODO: Write to Firestore `patient_profiles`, e.g.
    //   await FirebaseFirestore.instance
    //       .collection('patient_profiles')
    //       .doc(uid)
    //       .set({...});
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSaving = false);

    // On success, land the user in the app:
    //   context.go(AppRoutes.home);
  }

  String get _dobLabel {
    if (_dob == null) return 'Select your date of birth';
    return '${_dob!.day.toString().padLeft(2, '0')}'
        '/${_dob!.month.toString().padLeft(2, '0')}'
        '/${_dob!.year}';
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text('Set up your profile', style: AppTextStyles.h1),
                    SizedBox(height: 8.h),
                    Text(
                      'This helps doctors give you better care and powers your '
                      'health tracking.',
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: 28.h),

                    const NeuFieldLabel('Full name'),
                    NeuInsetSurface(
                      height: 52.h,
                      child: TextField(
                        controller: _nameController,
                        style: AppTextStyles.body,
                        textCapitalization: TextCapitalization.words,
                        decoration: _bareInput('Enter your name'),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    const NeuFieldLabel('Date of birth'),
                    GestureDetector(
                      onTap: _pickDob,
                      child: NeuInsetSurface(
                        height: 52.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _dobLabel,
                                style: AppTextStyles.body.copyWith(
                                  color: _dob == null
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 17.sp,
                              color: AppColors.navy,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    const NeuFieldLabel('Gender'),
                    Row(
                      children: _genders.map((g) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: NeuChip(
                            label: g,
                            selected: _gender == g,
                            onTap: () => setState(() => _gender = g),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),

                    const NeuFieldLabel('City'),
                    NeuInsetSurface(
                      height: 52.h,
                      child: TextField(
                        controller: _cityController,
                        style: AppTextStyles.body,
                        textCapitalization: TextCapitalization.words,
                        decoration: _bareInput('Enter City'),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 14.sp, color: AppColors.textSecondary),
                        SizedBox(width: 6.w),
                        Text(
                          'Optional — you can add these later',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NeuFieldLabel('Height (cm)'),
                              NeuInsetSurface(
                                height: 52.h,
                                child: TextField(
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: AppTextStyles.body,
                                  decoration: _bareInput('Enter Height'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NeuFieldLabel('Weight (kg)'),
                              NeuInsetSurface(
                                height: 52.h,
                                child: TextField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: AppTextStyles.body,
                                  decoration: _bareInput('Enter Weight'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    const NeuFieldLabel('Blood type'),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: _bloodTypes.map((b) {
                        return NeuChip(
                          label: b,
                          selected: _bloodType == b,
                          onTap: () => setState(() => _bloodType = b),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: NeuPillButton(
                enabled: _isValid && !_isSaving,
                loading: _isSaving,
                onTap: _save,
                label: 'Finish setup',
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _bareInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySecondary,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      filled: false,
      isDense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}