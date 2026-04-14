import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/router/router.dart';
import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

const _onboardingCompleteKey = 'onboarding_complete';

/// Three-screen onboarding walkthrough shown on first launch.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.leaderboard_outlined,
      title: S.onboardingTitle1,
      body: S.onboardingBody1,
    ),
    _OnboardingPage(
      icon: Icons.group_outlined,
      title: S.onboardingTitle2,
      body: S.onboardingBody2,
    ),
    _OnboardingPage(
      icon: Icons.verified_outlined,
      title: S.onboardingTitle3,
      body: S.onboardingBody3,
    ),
  ];

  Future<void> _complete() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    // Update in-memory state so router redirect sees the change immediately
    ref.read(onboardingCompleteProvider.notifier).state = true;
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
                child: TextButton(
                  onPressed: _complete,
                  child: Text(S.skip,
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.textTertiary)),
                ),
              ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  HapticFeedback.selectionClick();
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(20),
                            borderRadius: BorderRadius.circular(40),
                            border:
                                Border.all(color: AppColors.accent, width: 2),
                          ),
                          child:
                              Icon(page.icon, color: AppColors.accent, size: 36),
                        ),
                        const SizedBox(height: 32),
                        Text(page.title, style: AppTextStyles.displayLarge),
                        const SizedBox(height: 16),
                        Text(
                          page.body,
                          style: AppTextStyles.bodySecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                children: [
                  // Page dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.accent
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _currentPage == _pages.length - 1
                          ? _complete
                          : () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? S.getStarted
                            : S.next,
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.background),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String body;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });
}
