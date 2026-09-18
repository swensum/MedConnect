import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';

import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';
import 'package:med_connect/screen/Profile/Doctor%20profile/doctor_kyc_pending_screen.dart';

const List<String> _specializations = [
  'General physician',
  'Cardiologist',
  'Dermatologist',
  'Pediatrician',
  'Gynecologist',
  'Orthopedic',
  'Neurologist',
  'Psychiatrist',
  'Dentist',
  'Other',
];

class DoctorKycScreen extends StatefulWidget {
  const DoctorKycScreen({super.key, required this.phone});

  final String phone;

  @override
  State<DoctorKycScreen> createState() => _DoctorKycScreenState();
}

class _DoctorKycScreenState extends State<DoctorKycScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _otherSpecializationController =
      TextEditingController();

  String? _specialization;

  // Holds the actual picked file (name, size, path/bytes) so it's ready
  // to upload once Storage is wired up later — for now we just read
  // .name for the UI.
  PlatformFile? _licenseFile;
  PlatformFile? _degreeFile;
  PlatformFile? _clinicProofFile;

  bool _isSubmitting = false;
  bool _isSubmitted = false;

  String? get _licenseFileName => _licenseFile?.name;
  String? get _degreeFileName => _degreeFile?.name;
  String? get _clinicProofFileName => _clinicProofFile?.name;

  bool get _isValid =>
      _nameController.text.trim().length >= 2 &&
      _specialization != null &&
      (_specialization != 'Other' ||
          _otherSpecializationController.text.trim().isNotEmpty) &&
      _licenseController.text.trim().isNotEmpty &&
      _experienceController.text.trim().isNotEmpty &&
      _licenseFile != null &&
      _degreeFile != null;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _nameController,
      _licenseController,
      _experienceController,
      _feeController,
      _otherSpecializationController,
    ]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    _otherSpecializationController.dispose();
    super.dispose();
  }

  /// Opens the native file picker restricted to PDF/JPG/PNG, with a basic
  /// size guard. Calls [onPicked] with the selected file, or does nothing
  /// if the user cancels.
  Future<void> _pickFile(void Function(PlatformFile file) onPicked) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result == null || result.files.isEmpty) return; // user cancelled

      final file = result.files.single;

      const maxSizeBytes = 10 * 1024 * 1024; // 10 MB
      if (file.size > maxSizeBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File must be under 10 MB')),
          );
        }
        return;
      }

      HapticFeedback.selectionClick();
      onPicked(file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Couldn\'t open file picker: $e')),
        );
      }
    }
  }
Future<void> _submit() async {
    if (!_isValid || _isSubmitting) return;
    setState(() => _isSubmitting = true);

    // TODO: once backend is wired up — upload _licenseFile / _degreeFile /
    // _clinicProofFile (each has .path on mobile/desktop or .bytes on web)
    // to storage, then write the doctor_profiles doc with those URLs and
    // verified_status: 'pending'.
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    // Swap the form for a success view instead of navigating immediately —
    // gives the doctor a clear confirmation before landing in the app.
    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    // Land the doctor on the "pending review" screen — admin approval
    // gates them from appearing in doctor discovery (Section 2).
    context.pushReplacement(
      AppRoutes.kycPendingReview,
      extra: DoctorKycStatus.pending,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isSubmitted ? const _SubmittedView() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      key: const ValueKey('kyc-form'),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                const RoleBadge(role: UserRole.doctor),
                SizedBox(height: 24.h),
                Text('Verify your practice', style: AppTextStyles.h1),
                SizedBox(height: 8.h),
                Text(
                  'This lets us confirm you\'re a licensed doctor before '
                  'patients can find and book you.',
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
                    decoration: _bareInput('Enter you name'),
                  ),
                ),
                SizedBox(height: 20.h),

                const NeuFieldLabel('Specialization'),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: _specializations.map((s) {
                    return NeuChip(
                      label: s,
                      selected: _specialization == s,
                      onTap: () => setState(() => _specialization = s),
                    );
                  }).toList(),
                ),

                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: _specialization == 'Other'
                      ? Padding(
                          padding: EdgeInsets.only(top: 14.h),
                          child: NeuInsetSurface(
                            height: 52.h,
                            child: TextField(
                              controller: _otherSpecializationController,
                              style: AppTextStyles.body,
                              textCapitalization: TextCapitalization.words,
                              decoration:
                                  _bareInput('Enter your specialization'),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                SizedBox(height: 20.h),

                const NeuFieldLabel('Medical license number'),
                NeuInsetSurface(
                  height: 52.h,
                  child: TextField(
                    controller: _licenseController,
                    style: AppTextStyles.body,
                    decoration: _bareInput('Enter medical licence no.'),
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
                          const NeuFieldLabel('Experience (yrs)'),
                          NeuInsetSurface(
                            height: 52.h,
                            child: TextField(
                              controller: _experienceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: AppTextStyles.body,
                              decoration: _bareInput('Enter Exp..'),
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
                          const NeuFieldLabel('Consultation fee'),
                          NeuInsetSurface(
                            height: 52.h,
                            child: TextField(
                              controller: _feeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: AppTextStyles.body,
                              decoration: _bareInput('Enter Fee'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),

                Text('Verification documents', style: AppTextStyles.h3),
                SizedBox(height: 4.h),
                Text(
                  'Clear photos or PDFs — our team reviews these before '
                  'your profile goes live.',
                  style: AppTextStyles.caption,
                ),
                SizedBox(height: 16.h),

                NeuUploadTile(
                  label: 'Medical license',
                  fileName: _licenseFileName,
                  onTap: () =>
                      _pickFile((f) => setState(() => _licenseFile = f)),
                ),
                SizedBox(height: 12.h),
                NeuUploadTile(
                  label: 'Degree certificate',
                  fileName: _degreeFileName,
                  onTap: () =>
                      _pickFile((f) => setState(() => _degreeFile = f)),
                ),
                SizedBox(height: 12.h),
                NeuUploadTile(
                  label: 'Clinic / hospital proof',
                  sublabel: 'Optional — add later if you don\'t have one yet',
                  fileName: _clinicProofFileName,
                  onTap: () =>
                      _pickFile((f) => setState(() => _clinicProofFile = f)),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0.h),
          child: NeuPillButton(
            enabled: _isValid && !_isSubmitting,
            loading: _isSubmitting,
            onTap: _submit,
            label: 'Submit for review',
          ),
        ),
      ],
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

/// Shown in place of the form once the KYC docs are submitted.
class _SubmittedView extends StatelessWidget {
  const _SubmittedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('kyc-submitted'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NeuSuccessCheck(),
            SizedBox(height: 20.h),
            Text('Submitted for review', style: AppTextStyles.h2),
            SizedBox(height: 6.h),
            Text(
              'We\'ll verify your documents and notify you once your '
              'profile is approved.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}