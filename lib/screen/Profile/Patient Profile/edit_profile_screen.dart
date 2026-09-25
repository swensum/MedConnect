import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/patient_profile_model.dart';
import 'package:med_connect/providers/patient_profile_providers.dart';

const List<String> _genders = ['Male', 'Female', 'Other'];
const List<String> _bloodTypes = [
  'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
];

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

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
    final profile = ref.read(patientProfileProvider);

    _nameController = TextEditingController(text: profile?.name ?? '');
    _cityController = TextEditingController(text: profile?.city ?? '');
    _heightController =
        TextEditingController(text: profile?.heightCm?.toString() ?? '');
    _weightController =
        TextEditingController(text: profile?.weightKg?.toString() ?? '');
    _dob = profile?.dob;
    _gender = profile?.gender;
    _bloodType = profile?.bloodType;

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

    // TODO: also write these changes to Firestore `patient_profiles` once
    // the backend is wired up.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final existing = ref.read(patientProfileProvider);
    ref.read(patientProfileProvider.notifier).state = PatientProfile(
      name: _nameController.text.trim(),
      phone: existing?.phone ?? '', // phone isn't editable here
      dob: _dob!,
      gender: _gender!,
      city: _cityController.text.trim(),
      heightCm: int.tryParse(_heightController.text.trim()),
      weightKg: int.tryParse(_weightController.text.trim()),
      bloodType: _bloodType,
    );

    setState(() => _isSaving = false);
    if (!mounted) return;
    context.pop();
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
                  Text('Edit profile', style: AppTextStyles.h2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    SizedBox(height: 20.h),

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
                                  decoration:
                                      bareInputDecoration('Enter Height'),
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
                                  decoration:
                                      bareInputDecoration('Enter Weight'),
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
                label: 'Save changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}