import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/patient_home_models.dart';

class AppointmentsNotifier extends StateNotifier<List<AppointmentPreview>> {
  AppointmentsNotifier() : super([]);

  void add(AppointmentPreview appointment) {
    state = [...state, appointment];
  }

  void cancel(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<AppointmentPreview>>(
  (ref) => AppointmentsNotifier(),
);

/// The single nearest upcoming appointment, for the Home tab's card.
final nextAppointmentProvider = Provider<AppointmentPreview?>((ref) {
  final upcoming = ref.watch(appointmentsProvider).where((a) => !a.isPast).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return upcoming.isEmpty ? null : upcoming.first;
});