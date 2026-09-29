import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/nav_providers.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/Dashboard/doctor_home_tab.dart';


class DoctorHomeShell extends ConsumerWidget {
  const DoctorHomeShell({super.key});

  static const _items = [
    NeuBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NeuBottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_month_rounded,
      label: 'Appointments',
    ),
    NeuBottomNavItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Patients',
    ),
    NeuBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(doctorTabIndexProvider);

    return Scaffold(
      backgroundColor: kNeuBg,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: tabIndex,
          children: const [
            DoctorHomeTab(),
            _PlaceholderTab(label: 'Appointments'),
            _PlaceholderTab(label: 'Patients'),
            _PlaceholderTab(label: 'Profile'),
          ],
        ),
      ),
      bottomNavigationBar: NeuBottomNavBar(
        items: _items,
        currentIndex: tabIndex,
        onTap: (i) => ref.read(doctorTabIndexProvider.notifier).state = i,
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label — coming soon', style: AppTextStyles.bodySecondary),
    );
  }
}