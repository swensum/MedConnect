
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/doctor_account_model.dart';


final doctorAccountProvider = StateProvider<DoctorAccount?>((ref) => null);

final doctorAvailabilityProvider = StateProvider<bool>((ref) => true);