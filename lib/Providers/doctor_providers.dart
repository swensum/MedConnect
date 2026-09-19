import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/patient_home_models.dart';

final doctorsProvider = Provider<List<DoctorPreview>>((ref) {
  return allDoctors;
});

/// Current text in the discovery screen's search field.
final doctorSearchQueryProvider = StateProvider<String>((ref) => '');

/// Currently selected specialization filter chip ("All" by default).
final specializationFilterProvider = StateProvider<String>((ref) => 'All');

/// Doctors after applying both the search query and specialization filter.
final filteredDoctorsProvider = Provider<List<DoctorPreview>>((ref) {
  final doctors = ref.watch(doctorsProvider);
  final query = ref.watch(doctorSearchQueryProvider).trim().toLowerCase();
  final specialization = ref.watch(specializationFilterProvider);

  return doctors.where((d) {
    final matchesFilter =
        specialization == 'All' || d.specialization == specialization;
    final matchesQuery = query.isEmpty ||
        d.name.toLowerCase().contains(query) ||
        d.specialization.toLowerCase().contains(query);
    return matchesFilter && matchesQuery;
  }).toList();
});

final selectedDoctorProvider = StateProvider<DoctorPreview?>((ref) => null);