import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/components/patient_dashboard/Doctor_Screen/book_appointment_screen.dart';
import 'package:med_connect/components/patient_dashboard/Doctor_Screen/booking_confirm_screen.dart';
import 'package:med_connect/components/patient_dashboard/Doctor_Screen/doctor_discovery_screen.dart';
import 'package:med_connect/components/patient_dashboard/Doctor_Screen/doctor_profile_screen.dart';
import 'package:med_connect/components/patient_dashboard/Doctor_Screen/payment_checkout_screen.dart';
import 'package:med_connect/components/patient_dashboard/Lab%20Screen%20/lab_test_discovery_screen.dart';
import 'package:med_connect/models/patient_home_models.dart';
import 'package:med_connect/models/payment_models.dart';
import 'package:med_connect/screen/AuthScreen/phone_auth/otp_verify_screen.dart';
import 'package:med_connect/screen/AuthScreen/phone_auth/phone_auth_screen.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';
import 'package:med_connect/screen/Dashboard/patient_home_shell.dart';
import 'package:med_connect/screen/Profile/Doctor%20profile/doctor_kyc_screen.dart';
import 'package:med_connect/screen/Profile/Doctor%20profile/doctor_kyc_pending_screen.dart';
import 'package:med_connect/screen/Profile/Patient%20Profile/edit_profile_screen.dart';
import 'package:med_connect/screen/Profile/Patient%20Profile/patient_profile_screen.dart';
import 'package:med_connect/screen/onBoardingscrren/onboarding.dart';
import 'package:med_connect/screen/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const phoneEntry = '/phone-entry';
  static const otpVerify = '/otp-verify';
  static const patientProfileSetup = '/patient-profile-setup';
  static const doctorKyc = '/doctor-kyc';
  static const String kycPendingReview = '/kyc-pending-review';
  static const String patientHome = '/patient-home';
  static const String doctorDiscovery = '/doctor-discovery';
  static const String doctorProfile = '/doctor-profile';
  static const String bookAppointment = '/book-appointment';
  static const String bookingConfirm = '/booking-confirm';
  static const String paymentCheckout = '/payment-checkout';
  static const String editProfile = '/edit-profile';
  static const String labTestDiscovery = '/lab-test-discovery';
}

CustomTransitionPage slidePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incoming = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final outgoing =
          Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.15, 0),
          ).animate(
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeOutCubic,
            ),
          );

      return SlideTransition(
        position: outgoing,
        child: SlideTransition(position: incoming, child: child),
      );
    },
  );
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.patientProfileSetup,
    routes: [
      // No slide here — splash has its own pulse/zoom entrance.
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // No slide here — onboarding's own PageView swipe is the motion.
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Every route from here on uses the shared slide transition.
      GoRoute(
        path: AppRoutes.roleSelection,
        pageBuilder: (context, state) =>
            slidePage(const RoleSelectionScreen(), state),
      ),
      GoRoute(
        path: AppRoutes.phoneEntry,
        pageBuilder: (context, state) {
          final role = state.extra as UserRole;
          return slidePage(PhoneAuthScreen(role: role), state);
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerify,
        pageBuilder: (context, state) {
          final (phone, role) = state.extra as (String, UserRole);
          return slidePage(OtpVerifyScreen(phone: phone, role: role), state);
        },
      ),
      GoRoute(
        path: AppRoutes.patientProfileSetup,
        pageBuilder: (context, state) {
          final phone = state.extra is String
              ? state.extra as String
              : '9800000000';
          return slidePage(PatientProfileSetupScreen(phone: phone), state);
        },
      ),
      GoRoute(
        path: AppRoutes.doctorKyc,
        pageBuilder: (context, state) {
          final phone = state.extra as String;
          return slidePage(DoctorKycScreen(phone: phone), state);
        },
      ),
      GoRoute(
        path: AppRoutes.kycPendingReview,
        pageBuilder: (context, state) {
          final status = state.extra is DoctorKycStatus
              ? state.extra as DoctorKycStatus
              : DoctorKycStatus.pending;
          return slidePage(DoctorKycPendingScreen(status: status), state);
        },
      ),
      GoRoute(
        path: AppRoutes.patientHome,
        pageBuilder: (context, state) {
          final patientName = state.extra is String
              ? state.extra as String
              : 'there';
          return slidePage(PatientHomeShell(patientName: patientName), state);
        },
      ),
      // inside AppRouter.router routes list, after the patientHome route
      GoRoute(
        path: AppRoutes.doctorDiscovery,
        pageBuilder: (context, state) {
          final initialSpecialization = state.extra is String
              ? state.extra as String
              : null;
          return slidePage(
            DoctorDiscoveryScreen(initialSpecialization: initialSpecialization),
            state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.doctorProfile,
        pageBuilder: (context, state) =>
            slidePage(const DoctorProfileScreen(), state),
      ),
      GoRoute(
        path: AppRoutes.bookAppointment,
        pageBuilder: (context, state) =>
            slidePage(const BookAppointmentScreen(), state),
      ),
      GoRoute(
        path: AppRoutes.bookingConfirm,
        pageBuilder: (context, state) =>
            slidePage(const BookingConfirmScreen(), state),
      ),
      GoRoute(
        path: AppRoutes.paymentCheckout,
        pageBuilder: (context, state) {
          final (method, appointment) =
              state.extra as (PaymentMethod, AppointmentPreview);
          return slidePage(
            PaymentCheckoutScreen(method: method, appointment: appointment),
            state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        pageBuilder: (context, state) =>
            slidePage(const EditProfileScreen(), state),
      ),
      GoRoute(
        path: AppRoutes.labTestDiscovery,
        pageBuilder: (context, state) =>
            slidePage(const LabTestDiscoveryScreen(), state),
      ),
    ],
  );
}
