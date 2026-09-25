import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/patient_profile_model.dart';
import 'package:med_connect/providers/patient_profile_providers.dart';

const List<String> _genders = ['Male', 'Female', 'Other'];
const List<String> _bloodTypes = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

class PatientProfileSetupScreen extends ConsumerStatefulWidget {
  const PatientProfileSetupScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<PatientProfileSetupScreen> createState() =>
      _PatientProfileSetupScreenState();
}

class _PatientProfileSetupScreenState
    extends ConsumerState<PatientProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _dob;
  String? _gender;
  String? _bloodType;
  bool _isSaving = false;
  bool _isSaved = false;

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
    final picked = await showNeuDatePicker(
      context,
      initialDate: _dob ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!_isValid || _isSaving) return;
    setState(() => _isSaving = true);

    // TODO: Write to Firestore `patient_profiles` here too, once backend
    // is wired up — the provider write below is what feeds the Profile
    // tab for now.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Save into the shared provider so the Profile tab (and anywhere
    // else in the app) can read this patient's details.
    ref.read(patientProfileProvider.notifier).state = PatientProfile(
      name: _nameController.text.trim(),
      phone: widget.phone,
      dob: _dob!,
      gender: _gender!,
      city: _cityController.text.trim(),
      heightCm: int.tryParse(_heightController.text.trim()),
      weightKg: int.tryParse(_weightController.text.trim()),
      bloodType: _bloodType,
    );

    setState(() {
      _isSaving = false;
      _isSaved = true;
    });

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    // Land the user in the app.
    context.pushReplacement(
      AppRoutes.patientHome,
      extra: _nameController.text.trim(),
    );
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

      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isSaved ? const _SuccessView() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      key: const ValueKey('profile-form'),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
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
                    decoration: bareInputDecoration('Enter your name'),
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
                    decoration: bareInputDecoration('Enter City'),
                  ),
                ),
                SizedBox(height: 28.h),

                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14.sp,
                      color: AppColors.textSecondary,
                    ),
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
                              decoration: bareInputDecoration('Enter Height'),
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
                              decoration: bareInputDecoration('Enter Weight'),
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
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 3.h),
          child: NeuPillButton(
            enabled: _isValid && !_isSaving,
            loading: _isSaving,
            onTap: _save,
            label: 'Finish setup',
          ),
        ),
      ],
    );
  }
}

/// Shown in place of the form once the profile save succeeds.
class _SuccessView extends StatelessWidget {
  const _SuccessView();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('profile-success'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NeuSuccessCheck(),
            SizedBox(height: 20.h),
            Text('All set!', style: AppTextStyles.h2),
            SizedBox(height: 6.h),
            Text(
              'Setting up your health dashboard...',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
