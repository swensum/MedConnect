import 'package:flutter/material.dart';

class HealthMetric {
  const HealthMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
}

const List<HealthMetric> mockHealthMetrics = [
  HealthMetric(
    icon: Icons.directions_walk_rounded,
    label: 'Steps',
    value: '6,248',
    accentColor: Color(0xFF3D7DF6),
  ),
  HealthMetric(
    icon: Icons.water_drop_outlined,
    label: 'Water',
    value: '1.4L',
    accentColor: Color(0xFF2EA6D6),
  ),
  HealthMetric(
    icon: Icons.bedtime_outlined,
    label: 'Sleep',
    value: '6h 40m',
    accentColor: Color(0xFF7C6FE0),
  ),
  HealthMetric(
    icon: Icons.favorite_border_rounded,
    label: 'Heart rate',
    value: '78 bpm',
    accentColor: Color(0xFFD2484A),
  ),
];

class RecordCategory {
  const RecordCategory({
    required this.icon,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final String title;
  final int count; // number of documents in that category
}

// TODO: swap for real counts once Records data is wired up.
const List<RecordCategory> recordCategories = [
  RecordCategory(
    icon: Icons.medication_outlined,
    title: 'Prescriptions',
    count: 4,
  ),
  RecordCategory(icon: Icons.biotech_outlined, title: 'Lab reports', count: 2),
  RecordCategory(
    icon: Icons.description_outlined,
    title: 'Diagnosis notes',
    count: 3,
  ),
  RecordCategory(
    icon: Icons.vaccines_outlined,
    title: 'Vaccinations',
    count: 1,
  ),
];
