class DoctorAccount {
  const DoctorAccount({
    required this.id,
    required this.name,
    required this.specialization,
    this.experienceYears,
    this.fee,
  });

  final String id;
  final String name;
  final String specialization;
  final int? experienceYears;
  final int? fee;
}