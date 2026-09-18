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

/// A single upcoming appointment — used by TodayAppointmentCard.
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