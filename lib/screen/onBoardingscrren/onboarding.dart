import 'package:flutter/material.dart';
import 'package:med_connect/Theme/theme.dart';

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.body,
    required this.visual,
  });

  final String title;
  final String body;
  final Widget visual;
}

final List<_OnboardingSlide> _slides = [
  const _OnboardingSlide(
    title: 'Find the right doctor',
    body:
        'Search verified doctors by specialty, city, and availability, then check ratings before you book.',
    visual: _DoctorDiscoveryVisual(),
  ),
  const _OnboardingSlide(
    title: 'Consult from anywhere',
    body:
        'Chat or video call your doctor and share medical reports or X-rays instantly during the session.',
    visual: _ConsultVisual(),
  ),
  const _OnboardingSlide(
    title: 'Track your health',
    body:
        'Log your vitals and follow exercise plans your doctor assigns, so you only see what is relevant to you.',
    visual: _VitalsVisual(),
  ),
  const _OnboardingSlide(
    title: 'Give blood, save lives',
    body:
        'Register as a donor or find a matching donor nearby when someone needs blood urgently.',
    visual: _DonationVisual(),
  ),
];

// ---- Slide 1: concentric circle with a single icon ----
class _DoctorDiscoveryVisual extends StatelessWidget {
  const _DoctorDiscoveryVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 176,
            height: 176,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.navy,
            ),
          ),
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              size: 48,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Slide 2: two connected avatars with a video-call badge ----
class _ConsultVisual extends StatelessWidget {
  const _ConsultVisual();

  Widget _avatar({required Color bg, required Color iconColor}) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Icon(Icons.person_outline, size: 30, color: iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _avatar(bg: AppColors.paleBlue, iconColor: AppColors.navy),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      5,
                      (_) => Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.mutedBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _avatar(bg: AppColors.navy, iconColor: AppColors.white),
            ],
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navy,
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.videocam_outlined,
                size: 20,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Slide 3: mini vitals stat cards, echoing the home screen ----
class _VitalsVisual extends StatelessWidget {
  const _VitalsVisual();

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      width: 92,
      height: 104,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paleBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.navy),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: AppColors.navy),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _statCard(Icons.favorite_border, '72 bpm', 'Heart rate'),
          const SizedBox(width: 12),
          Transform.translate(
            offset: const Offset(0, -14),
            child: _statCard(
              Icons.directions_walk,
              '4,210',
              'Steps today',
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Slide 4: overlapping circles representing donor matching ----
class _DonationVisual extends StatelessWidget {
  const _DonationVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20,
            child: Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.paleBlue,
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mutedBlue.withValues(alpha: 0.7),
              ),
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.water_drop_outlined,
              size: 32,
              color: AppColors.navy,
            ),
          ),
          const Positioned(
            top: 18,
            left: 34,
            child: _BloodTag(label: 'A+'),
          ),
          const Positioned(
            top: 18,
            right: 34,
            child: _BloodTag(label: 'O-'),
          ),
        ],
      ),
    );
  }
}

class _BloodTag extends StatelessWidget {
  const _BloodTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Small reusable wrapper that scales down slightly on press, for tactile
/// button feedback without needing a new StatefulWidget per button.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Drives the staggered entrance of the visual, title, and body each time
  // a slide settles into view.
  late final AnimationController _contentController;
  late final Animation<double> _visualFade;
  late final Animation<Offset> _visualSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _bodyFade;
  late final Animation<Offset> _bodySlide;

  bool get _isLastPage => _currentPage == _slides.length - 1;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _visualFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _visualSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(_visualFade);

    _titleFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.15, 0.8, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_titleFade);

    _bodyFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _bodySlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_bodyFade);

    _contentController.forward();
  }

  void _goToNext() {
    if (_isLastPage) {
      _finishOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _skip() => _pageController.jumpToPage(_slides.length - 1);

  void _finishOnboarding() {
    // Replace with your actual next screen, e.g.:
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => const LoginScreen()),
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: just a standalone Skip button, right-aligned.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLastPage ? 0.0 : 1.0,
                  child: GestureDetector(
                    onTap: _isLastPage ? null : _skip,
                    child: Text('Skip', style: AppTextStyles.bodySecondary),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _contentController.forward(from: 0);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double page = index.toDouble();
                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions) {
                        page = _pageController.page ??
                            _currentPage.toDouble();
                      }
                      final delta = (page - index);
                      final scale =
                          1 - (delta.abs() * 0.18).clamp(0.0, 0.3);
                      final opacity =
                          1 - (delta.abs() * 0.7).clamp(0.0, 1.0);

                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: _visualFade,
                            child: SlideTransition(
                              position: _visualSlide,
                              child: slide.visual,
                            ),
                          ),
                          const SizedBox(height: 32),
                          FadeTransition(
                            opacity: _titleFade,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: Text(
                                slide.title,
                                textAlign: TextAlign.center,
                                style:
                                    AppTextStyles.h1.copyWith(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FadeTransition(
                            opacity: _bodyFade,
                            child: SlideTransition(
                              position: _bodySlide,
                              child: Text(
                                slide.body,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySecondary.copyWith(
                                  height: 1.6,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom bar: dot progress + circular next, or full-width CTA on last page.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isLastPage
                    ? _Pressable(
                        onTap: _goToNext,
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _goToNext,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Get started',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Row(
                        key: const ValueKey('next-row'),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(_slides.length, (index) {
                              final active = index == _currentPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOut,
                                margin: const EdgeInsets.only(right: 5),
                                width: active ? 18 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: active
                                      ? AppColors.navy
                                      : AppColors.mutedBlue,
                                ),
                              );
                            }),
                          ),
                          _Pressable(
                            onTap: _goToNext,
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.navy,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.navy.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: AppColors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}