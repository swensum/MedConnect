class PatientProfile {
  const PatientProfile({
    required this.name,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.city,
    this.heightCm,
    this.weightKg,
    this.bloodType,
  });

  final String name;
  final String phone;
  final DateTime dob;
  final String gender;
  final String city;
  final int? heightCm;
  final int? weightKg;
  final String? bloodType;

  int get age {
    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }
}