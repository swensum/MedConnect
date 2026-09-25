class LabTest {
  const LabTest({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.sampleType,
    this.reportTime = '24 hrs',
    this.homeSampleAvailable = true,
    this.description,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final String sampleType; // e.g. 'Blood', 'Urine'
  final String reportTime;
  final bool homeSampleAvailable;
  final String? description;
}

// TODO: swap for real lab/test catalog once backend is wired up.
const List<LabTest> allLabTests = [
  LabTest(
    id: 'cbc',
    name: 'Complete Blood Count (CBC)',
    category: 'Blood',
    price: 450,
    sampleType: 'Blood',
    reportTime: '12 hrs',
    description: 'Measures red cells, white cells, and platelets to check '
        'overall health and detect a range of disorders.',
  ),
  LabTest(
    id: 'lipid-profile',
    name: 'Lipid Profile',
    category: 'Blood',
    price: 900,
    sampleType: 'Blood',
    reportTime: '24 hrs',
    description: 'Checks cholesterol and triglyceride levels to assess '
        'heart disease risk.',
  ),
  LabTest(
    id: 'blood-sugar',
    name: 'Blood Sugar (Fasting)',
    category: 'Diabetes',
    price: 250,
    sampleType: 'Blood',
    reportTime: '6 hrs',
  ),
  LabTest(
    id: 'hba1c',
    name: 'HbA1c',
    category: 'Diabetes',
    price: 700,
    sampleType: 'Blood',
    reportTime: '24 hrs',
    description: 'Average blood sugar level over the past 2-3 months.',
  ),
  LabTest(
    id: 'thyroid-panel',
    name: 'Thyroid Panel (T3, T4, TSH)',
    category: 'Hormone',
    price: 1200,
    sampleType: 'Blood',
    reportTime: '24 hrs',
  ),
  LabTest(
    id: 'urine-routine',
    name: 'Urine Routine Examination',
    category: 'Urine',
    price: 300,
    sampleType: 'Urine',
    reportTime: '12 hrs',
    homeSampleAvailable: false,
  ),
  LabTest(
    id: 'liver-function',
    name: 'Liver Function Test (LFT)',
    category: 'Blood',
    price: 950,
    sampleType: 'Blood',
    reportTime: '24 hrs',
  ),
  LabTest(
    id: 'vitamin-d',
    name: 'Vitamin D',
    category: 'Vitamin',
    price: 1500,
    sampleType: 'Blood',
    reportTime: '48 hrs',
  ),
  LabTest(
    id: 'full-body-checkup',
    name: 'Full Body Checkup Package',
    category: 'Package',
    price: 3500,
    sampleType: 'Blood + Urine',
    reportTime: '48 hrs',
    description: 'A comprehensive panel covering blood count, sugar, '
        'lipid profile, liver and kidney function, and more.',
  ),
];