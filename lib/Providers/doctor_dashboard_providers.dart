import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_connect/Providers/appointment_providers.dart';
import 'package:med_connect/Providers/doctor_account_providers.dart';
import 'package:med_connect/models/patient_home_models.dart';

final doctorAppointmentsProvider = Provider<List<AppointmentPreview>>((ref) {
  final doctor = ref.watch(doctorAccountProvider);
  final all = ref.watch(appointmentsProvider);
  if (doctor == null) return [];
  return all.where((a) => a.doctorId == doctor.id).toList();
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