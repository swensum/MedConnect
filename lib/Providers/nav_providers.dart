import 'package:flutter_riverpod/legacy.dart';

final patientTabIndexProvider = StateProvider<int>((ref) => 0);
final doctorTabIndexProvider = StateProvider<int>((ref) => 0);