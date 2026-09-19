import 'package:flutter/material.dart';

/// -------- Mock data (swap for real models/Firestore once wired up) -----

/// NOTE: unused now that QuickActionRow replaced the old specialization
/// shortcut row on the home tab — safe to delete if you don't plan to
/// reuse it elsewhere.
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

/// A single patient review shown on the doctor profile screen.
class DoctorReview {
  const DoctorReview({
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });

  final String patientName;
  final double rating;
  final String comment;

  /// Relative time label, e.g. '2 weeks ago'.
  final String timeAgo;
}

class DoctorPreview {
  const DoctorPreview({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experienceYears,
    required this.fee,
    required this.rating,
    this.bio,
    this.workplaceName,
    this.workplaceAddress,
    this.consultationModes = const ['In-clinic'],
    this.todaySlots = const [],
    this.reviews = const [],
  });

  final String id;
  final String name;
  final String specialization;
  final int experienceYears;
  final int fee;
  final double rating;
  final String? bio;

  /// Hospital/clinic the doctor is primarily associated with.
  final String? workplaceName;
  final String? workplaceAddress;

  /// e.g. ['In-clinic', 'Video call'] — shown as informational pills on
  /// the profile screen; the actual choice happens inside booking.
  final List<String> consultationModes;

  /// Quick-glance open slots for today, e.g. ['10:00 AM', '2:30 PM'].
  /// Empty means "no slots today" — the UI falls back to full booking.
  final List<String> todaySlots;

  final List<DoctorReview> reviews;

  int get reviewCount => reviews.length;
}

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

const List<DoctorPreview> allDoctors = [
  DoctorPreview(
    id: 'anita-sharma',
    name: 'Dr. Anita Sharma',
    specialization: 'Cardiologist',
    experienceYears: 12,
    fee: 800,
    rating: 4.8,
    bio: 'Specializes in heart disease prevention and management, with '
        'over a decade of clinical experience in cardiac care.',
    workplaceName: 'Koshi Zonal Hospital',
    workplaceAddress: 'Biratnagar-4, Koshi Province',
    consultationModes: ['In-clinic', 'Video call'],
    todaySlots: ['10:00 AM', '11:30 AM', '4:00 PM'],
    reviews: [
      DoctorReview(
        patientName: 'Sunil R.',
        rating: 5,
        comment: 'Very thorough and explained everything clearly. '
            'Didn\'t feel rushed at all.',
        timeAgo: '2 weeks ago',
      ),
      DoctorReview(
        patientName: 'Kamala T.',
        rating: 4.5,
        comment: 'Good experience, slight wait but worth it.',
        timeAgo: '1 month ago',
      ),
    ],
  ),
  DoctorPreview(
    id: 'bikash-thapa',
    name: 'Dr. Bikash Thapa',
    specialization: 'General physician',
    experienceYears: 7,
    fee: 500,
    rating: 4.6,
    workplaceName: 'City Care Clinic',
    workplaceAddress: 'Traffic Chowk, Biratnagar',
    consultationModes: ['In-clinic'],
    todaySlots: ['9:00 AM', '1:00 PM'],
  ),
  DoctorPreview(
    id: 'priya-koirala',
    name: 'Dr. Priya Koirala',
    specialization: 'Dermatologist',
    experienceYears: 9,
    fee: 700,
    rating: 4.9,
    workplaceName: 'Nobel Medical College',
    workplaceAddress: 'Kanchanbari, Biratnagar',
    consultationModes: ['In-clinic', 'Video call'],
    reviews: [
      DoctorReview(
        patientName: 'Anjali M.',
        rating: 5,
        comment: 'Cleared up my skin issue in just two visits.',
        timeAgo: '3 weeks ago',
      ),
    ],
  ),
  DoctorPreview(
    id: 'suresh-rai',
    name: 'Dr. Suresh Rai',
    specialization: 'Cardiologist',
    experienceYears: 15,
    fee: 900,
    rating: 4.7,
    workplaceName: 'Koshi Zonal Hospital',
    workplaceAddress: 'Biratnagar-4, Koshi Province',
    consultationModes: ['In-clinic'],
  ),
  DoctorPreview(
    id: 'meena-gurung',
    name: 'Dr. Meena Gurung',
    specialization: 'Pediatrician',
    experienceYears: 6,
    fee: 450,
    rating: 4.5,
    workplaceName: 'City Care Clinic',
    workplaceAddress: 'Traffic Chowk, Biratnagar',
    consultationModes: ['In-clinic', 'Video call'],
    todaySlots: ['2:00 PM', '3:30 PM'],
  ),
  DoctorPreview(
    id: 'rajesh-karki',
    name: 'Dr. Rajesh Karki',
    specialization: 'General physician',
    experienceYears: 4,
    fee: 400,
    rating: 4.3,
    workplaceName: 'Nobel Medical College',
    workplaceAddress: 'Kanchanbari, Biratnagar',
  ),
  DoctorPreview(
    id: 'sabina-lama',
    name: 'Dr. Sabina Lama',
    specialization: 'Dermatologist',
    experienceYears: 5,
    fee: 600,
    rating: 4.6,
    workplaceName: 'City Care Clinic',
    workplaceAddress: 'Traffic Chowk, Biratnagar',
    consultationModes: ['In-clinic', 'Video call'],
  ),
  DoctorPreview(
    id: 'nabin-adhikari',
    name: 'Dr. Nabin Adhikari',
    specialization: 'Neurologist',
    experienceYears: 11,
    fee: 1000,
    rating: 4.9,
    workplaceName: 'Koshi Zonal Hospital',
    workplaceAddress: 'Biratnagar-4, Koshi Province',
    reviews: [
      DoctorReview(
        patientName: 'Deepak S.',
        rating: 5,
        comment: 'Extremely knowledgeable, took time to answer all my '
            'questions.',
        timeAgo: '1 week ago',
      ),
    ],
  ),
  DoctorPreview(
    id: 'sunita-basnet',
    name: 'Dr. Sunita Basnet',
    specialization: 'Pediatrician',
    experienceYears: 8,
    fee: 500,
    rating: 4.7,
    workplaceName: 'Nobel Medical College',
    workplaceAddress: 'Kanchanbari, Biratnagar',
    todaySlots: ['11:00 AM'],
  ),
  DoctorPreview(
    id: 'kiran-shrestha',
    name: 'Dr. Kiran Shrestha',
    specialization: 'Dentist',
    experienceYears: 10,
    fee: 550,
    rating: 4.8,
    workplaceName: 'City Care Clinic',
    workplaceAddress: 'Traffic Chowk, Biratnagar',
    consultationModes: ['In-clinic'],
  ),
];

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