import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view_model/user_existance/user_existance_cubit.dart';

import '../../../core/routes/app_routes.dart';
import '../../widgets/on_boarding_page.dart';
import 'first_on_boarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  late List<Map<String, String>> onboardingData;

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    //todo: navigate to auth screen
    context.read<UserExistanceCubit>().finishOnboarding();
    Navigator.pushNamed(context, AppRoutes.loginScreenRoute);
  }

  void _skip() {
    debugPrint("Skip Onboarding");
  }

  @override
  Widget build(BuildContext context) {
    onboardingData = [
      {
        "image": AppAssets.onBoardingPage2,
        "title": AppLocalizations.of(context)!.discover_movies,
        "desc": AppLocalizations.of(context)!.explore_all_genres_desc
      },
      {
        "image": AppAssets.onBoardingPage3,
        "title": AppLocalizations.of(context)!.explore_all_genres,
        "desc": AppLocalizations.of(context)!.create_watchlists_desc
      },
      {
        "image": AppAssets.onBoardingPage4,
        "title": AppLocalizations.of(context)!.create_watchlists,
        "desc": AppLocalizations.of(context)!.create_watchlists_desc
      },
      {
        "image": AppAssets.onBoardingPage5,
        "title": AppLocalizations.of(context)!.rate_review_learn,
        "desc": AppLocalizations.of(context)!.rate_review_learn_desc
      },
      {
        "image": AppAssets.onBoardingPage6,
        "title": AppLocalizations.of(context)!.start_watching_now
      },
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => currentPage = index),
        children: [
          FirstOnboardingPage(onNext: _goToNextPage),
          ...onboardingData.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            bool isLast = index == onboardingData.length - 1;
            bool isSecond = index == 0; //  لأن دي أول صفحة بعد الأولى الخاصة

            return OnboardingPage(
              image: item["image"]!,
              title: item["title"]!,
              desc: item["desc"],
              onNext: isLast ? _finishOnboarding : _goToNextPage,
              onSkip: _skip,
              isLast: isLast,
              isSecond: isSecond,
              onBack: index > 0 ? _goToPreviousPage : null, // لو مش التانية
            );
          }),
        ],
      ),
    );
  }
}
