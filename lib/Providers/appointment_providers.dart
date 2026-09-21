
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/patient_home_models.dart';

/// The patient's next confirmed appointment, shown on the Home tab's
/// "Today's appointment" card. In-memory for now — swap for a Firestore
/// stream (most recent upcoming `appointments` doc for this patient)
/// once the backend is wired up.
final confirmedAppointmentProvider =
    StateProvider<AppointmentPreview?>((ref) => null);