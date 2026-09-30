import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:med_connect/Providers/doctor_account_providers.dart';
import 'package:med_connect/models/patient_home_models.dart';

List<AppointmentPreview> _demoAppointmentsFor(String doctorId) {
  final today = DateTime.now();
  final tomorrow = today.add(const Duration(days: 1));

  return [
    AppointmentPreview.fromBooking(
      doctorId: doctorId,
      doctorName: 'Dr. Anita Sharma',
      specialization: 'Cardiologist',
      date: today,
      time: '10:00 AM',
      consultationMode: 'Video call',
      patientName: 'Ramesh Koirala',
    ),
    AppointmentPreview.fromBooking(
      doctorId: doctorId,
      doctorName: 'Dr. Anita Sharma',
      specialization: 'Cardiologist',
      date: today,
      time: '2:30 PM',
      consultationMode: 'In-clinic',
      patientName: 'Sunita Basnet',
    ),
    AppointmentPreview.fromBooking(
      doctorId: doctorId,
      doctorName: 'Dr. Anita Sharma',
      specialization: 'Cardiologist',
      date: today,
      time: '4:00 PM',
      consultationMode: 'Video call',
      patientName: 'Bikash Thapa',
    ),
    AppointmentPreview.fromBooking(
      doctorId: doctorId,
      doctorName: 'Dr. Anita Sharma',
      specialization: 'Cardiologist',
      date: tomorrow,
      time: '11:00 AM',
      consultationMode: 'In-clinic',
      patientName: 'Kamala Tamang',
    ),
  ];
}

/// All appointments booked with the currently signed-in doctor.
/// Currently returns hand-built demo data for design purposes — swap the
/// body back to filtering the real appointmentsProvider (commented below)
/// once you're ready to test against real patient bookings again.
final doctorAppointmentsProvider = Provider<List<AppointmentPreview>>((ref) {
  final doctor = ref.watch(doctorAccountProvider);
  if (doctor == null) return [];

  // DEMO: return hardcoded appointments.
  return _demoAppointmentsFor(doctor.id);

  // REAL: filter actual bookings from the shared appointmentsProvider.
  // final all = ref.watch(appointmentsProvider);
  // return all.where((a) => a.doctorId == doctor.id).toList();
});

final doctorUpcomingAppointmentsProvider =
    Provider<List<AppointmentPreview>>((ref) {
  final upcoming =
      ref.watch(doctorAppointmentsProvider).where((a) => !a.isPast).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
  return upcoming;
});

final doctorTodayAppointmentsProvider = Provider<List<AppointmentPreview>>((ref) {
  final today = DateTime.now();
  return ref.watch(doctorUpcomingAppointmentsProvider).where((a) {
    return a.date.year == today.year &&
        a.date.month == today.month &&
        a.date.day == today.day;
  }).toList();
});

final doctorNextAppointmentProvider = Provider<AppointmentPreview?>((ref) {
  final upcoming = ref.watch(doctorUpcomingAppointmentsProvider);
  return upcoming.isEmpty ? null : upcoming.first;
});
final doctorWeeklyEarningsProvider = Provider<int>((ref) {
  final doctor = ref.watch(doctorAccountProvider);
  if (doctor == null || doctor.fee == null) return 0;

  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  final thisWeekCount = ref.watch(doctorAppointmentsProvider).where((a) {
    return !a.date.isBefore(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)) &&
        !a.date.isAfter(DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day));
  }).length;

  return thisWeekCount * doctor.fee!;
});

/// Count of unique patients across all appointments (demo: distinct names).
final doctorTotalPatientsProvider = Provider<int>((ref) {
  final all = ref.watch(doctorAppointmentsProvider);
  return all.map((a) => a.patientName).toSet().length;
});