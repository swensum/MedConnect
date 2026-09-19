import 'package:flutter/material.dart';

/// -------- Mock data (swap for real models/Firestore once wired up) -----

class SpecializationShortcut {
  const SpecializationShortcut(this.label, this.icon);
  final String label;
  final IconData icon;
}

const List<SpecializationShortcut> specializationShortcuts = [
  SpecializationShortcut('General', Icons.medical_services_outlined),
  SpecializationShortcut('Cardiology', Icons.favorite_border_rounded),
  SpecializationShortcut('Dermatology', Icons.face_retouching_natural_rounded),
  SpecializationShortcut('Pediatrics', Icons.child_care_rounded),
  SpecializationShortcut('Dental', Icons.mood_outlined),
  SpecializationShortcut('Neurology', Icons.psychology_outlined),
];

class DoctorPreview {
  const DoctorPreview({
    required this.name,
    required this.specialization,
    required this.experienceYears,
    required this.fee,
    required this.rating,
  });

  final String name;
  final String specialization;
  final int experienceYears;
  final int fee;
  final double rating;
}

const List<DoctorPreview> topDoctors = [
  DoctorPreview(
    name: 'Dr. Anita Sharma',
    specialization: 'Cardiologist',
    experienceYears: 12,
    fee: 800,
    rating: 4.8,
  ),
  DoctorPreview(
    name: 'Dr. Bikash Thapa',
    specialization: 'General physician',
    experienceYears: 7,
    fee: 500,
    rating: 4.6,
  ),
  DoctorPreview(
    name: 'Dr. Priya Koirala',
    specialization: 'Dermatologist',
    experienceYears: 9,
    fee: 700,
    rating: 4.9,
  ),
];

class AppointmentPreview {
  const AppointmentPreview({
    required this.doctorName,
    required this.specialization,
    required this.dayNumber,
    required this.monthYear,
    required this.weekday,
    required this.time,
  });

  final String doctorName;
  final String specialization;
  final String dayNumber;
  final String monthYear;
  final String weekday;
  final String time;
}

// TODO: swap for the real next-upcoming appointment once wired up.
const AppointmentPreview? todaysAppointment = AppointmentPreview(
  doctorName: 'Dr. Anita Sharma',
  specialization: 'Cardiologist',
  dayNumber: '19',
  monthYear: 'Sep 2026',
  weekday: 'Friday',
  time: '4:30 PM',
);
// Add this below the existing `topDoctors` list.

const List<DoctorPreview> allDoctors = [
  DoctorPreview(
    name: 'Dr. Anita Sharma',
    specialization: 'Cardiologist',
    experienceYears: 12,
    fee: 800,
    rating: 4.8,
  ),
  DoctorPreview(
    name: 'Dr. Bikash Thapa',
    specialization: 'General physician',
    experienceYears: 7,
    fee: 500,
    rating: 4.6,
  ),
  DoctorPreview(
    name: 'Dr. Priya Koirala',
    specialization: 'Dermatologist',
    experienceYears: 9,
    fee: 700,
    rating: 4.9,
  ),
  DoctorPreview(
    name: 'Dr. Suresh Rai',
    specialization: 'Cardiologist',
    experienceYears: 15,
    fee: 900,
    rating: 4.7,
  ),
  DoctorPreview(
    name: 'Dr. Meena Gurung',
    specialization: 'Pediatrician',
    experienceYears: 6,
    fee: 450,
    rating: 4.5,
  ),
  DoctorPreview(
    name: 'Dr. Rajesh Karki',
    specialization: 'General physician',
    experienceYears: 4,
    fee: 400,
    rating: 4.3,
  ),
  DoctorPreview(
    name: 'Dr. Sabina Lama',
    specialization: 'Dermatologist',
    experienceYears: 5,
    fee: 600,
    rating: 4.6,
  ),
  DoctorPreview(
    name: 'Dr. Nabin Adhikari',
    specialization: 'Neurologist',
    experienceYears: 11,
    fee: 1000,
    rating: 4.9,
  ),
  DoctorPreview(
    name: 'Dr. Sunita Basnet',
    specialization: 'Pediatrician',
    experienceYears: 8,
    fee: 500,
    rating: 4.7,
  ),
  DoctorPreview(
    name: 'Dr. Kiran Shrestha',
    specialization: 'Dentist',
    experienceYears: 10,
    fee: 550,
    rating: 4.8,
  ),
];

/// -------- Home-tab additions: quick actions, hospitals, tip, exercises ---

/// A shortcut shown in the "What do you need today?" row.
class QuickAction {
  const QuickAction({
    required this.icon,
    required this.label,
    this.isEmergency = false,
  });

  final IconData icon;
  final String label;

  /// True only for the Emergency tile — drives the red accent color.
  final bool isEmergency;
}

const List<QuickAction> quickActions = [
  QuickAction(icon: Icons.medical_services_outlined, label: 'Doctor'),
  QuickAction(icon: Icons.biotech_outlined, label: 'Lab tests'),
  QuickAction(icon: Icons.local_hospital_outlined, label: 'Hospital'),
  QuickAction(icon: Icons.medication_outlined, label: 'Pharmacy'),
  QuickAction(
    icon: Icons.emergency_outlined,
    label: 'Emergency',
    isEmergency: true,
  ),
];

/// A nearby hospital/clinic preview shown in the "Hospitals near you" row.
class HospitalPreview {
  const HospitalPreview({
    required this.name,
    required this.distanceKm,
    required this.isOpen,
  });

  final String name;
  final double distanceKm;
  final bool isOpen;

  String get distanceLabel => distanceKm < 1
      ? '${(distanceKm * 1000).round()} m away'
      : '${distanceKm.toStringAsFixed(1)} km away';
}

const List<HospitalPreview> nearbyHospitals = [
  HospitalPreview(name: 'Koshi Zonal Hospital', distanceKm: 1.8, isOpen: true),
  HospitalPreview(
    name: 'Nobel Medical College',
    distanceKm: 3.2,
    isOpen: true,
  ),
  HospitalPreview(name: 'City Care Clinic', distanceKm: 0.8, isOpen: true),
];

/// The single "today's health tip" card.
class HealthTip {
  const HealthTip({required this.label, required this.text});

  final String label;
  final String text;
}

// TODO: swap for a real tip-of-the-day source once wired up.
const HealthTip todaysHealthTip = HealthTip(
  label: 'Hydration',
  text:
      'A glass of water before each meal helps with digestion and keeps '
      'you from mistaking thirst for hunger.',
);

/// A single doctor-recommended exercise in the "Exercises from your
/// doctor" list.
class ExercisePreview {
  const ExercisePreview({
    required this.icon,
    required this.name,
    required this.note,
    required this.durationLabel,
    required this.doctorName,
  });

  final IconData icon;
  final String name;
  final String note;
  final String durationLabel;
  final String doctorName;
}

const List<ExercisePreview> recommendedExercises = [
  ExercisePreview(
    icon: Icons.self_improvement_outlined,
    name: 'Knee stretches',
    note: 'Prescribed for joint mobility',
    durationLabel: '10 min · 3 sets',
    doctorName: 'Dr. Priya Sharma',
  ),
  ExercisePreview(
    icon: Icons.directions_walk_rounded,
    name: 'Morning walk',
    note: 'Builds cardiovascular stamina',
    durationLabel: '20 min · daily',
    doctorName: 'Dr. Priya Sharma',
  ),
  ExercisePreview(
    icon: Icons.air_rounded,
    name: 'Breathing exercise',
    note: 'Helps manage stress & sleep',
    durationLabel: '5 min · 2x a day',
    doctorName: 'Dr. Rajesh Karki',
  ),
];