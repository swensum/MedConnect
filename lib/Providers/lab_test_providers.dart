import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/lab_test_model.dart';

final labTestsProvider = Provider<List<LabTest>>((ref) => allLabTests);

final labTestSearchQueryProvider = StateProvider<String>((ref) => '');
final labTestCategoryFilterProvider = StateProvider<String>((ref) => 'All');

final filteredLabTestsProvider = Provider<List<LabTest>>((ref) {
  final tests = ref.watch(labTestsProvider);
  final query = ref.watch(labTestSearchQueryProvider).trim().toLowerCase();
  final category = ref.watch(labTestCategoryFilterProvider);

  return tests.where((t) {
    final matchesCategory = category == 'All' || t.category == category;
    final matchesQuery = query.isEmpty ||
        t.name.toLowerCase().contains(query) ||
        t.category.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});

final selectedLabTestProvider = StateProvider<LabTest?>((ref) => null);