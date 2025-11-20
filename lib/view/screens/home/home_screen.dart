import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/view/screens/home/tabs/browse/browse_tab.dart';
import 'package:movies_app/view/screens/home/tabs/home/home_tab.dart';
import 'package:movies_app/view/screens/home/tabs/profile/profile_tab.dart';
import 'package:movies_app/view/screens/home/tabs/search/search_tab.dart';
import 'package:movies_app/view_model/movies/movies_cubit.dart';

import '../../../core/constants/styles/app_assets.dart';
import '../../../core/constants/styles/app_colors.dart';
import '../../../data/models/categories/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int selectedCategoryIndex = 0;

    int? _lastTappedIndex;
  DateTime? _lastTapTime;


  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      HomeTab(
        selectedCategoryIndex: selectedCategoryIndex,
        onCategoryChanged: (newIndex) {
          setState(() {
            selectedCategoryIndex = newIndex;
          });
        },
      ),
      const SearchTab(),
      const BrowseTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      extendBody: true,
      body: tabs[selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(15.r), // responsive radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
  final now = DateTime.now();
  
  if (index == selectedIndex) {
    // If tapping the same tab that's already selected
    if (index == 0) {
      // Check if this is a double tap (within 500ms)
      if (_lastTappedIndex == 0 && 
          _lastTapTime != null && 
          now.difference(_lastTapTime!) < const Duration(milliseconds: 500)) {
        // This is a double tap on home tab - refresh movies
        context.read<MoviesCubit>().refreshMovies();
        _lastTapTime = null; // Reset to prevent multiple triggers
      } else {
        // First tap or tap after delay - just record the time
        _lastTappedIndex = 0;
        _lastTapTime = now;
      }
    }
  } else {
    // Tapping a different tab
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      setState(() {
        selectedCategoryIndex = 
            (selectedCategoryIndex + 1) % CategoryModel.categories.length;
      });
    }
  }
},

            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildBottomNavigationBarItem(
                index: 0,
                unselectedIconName: AppAssets.homeTab,
                selectedIconName: AppAssets.homeTabSelected,
              ),
              _buildBottomNavigationBarItem(
                index: 1,
                unselectedIconName: AppAssets.searchTab,
                selectedIconName: AppAssets.searchTabSelected,
              ),
              _buildBottomNavigationBarItem(
                index: 2,
                unselectedIconName: AppAssets.browseTab,
                selectedIconName: AppAssets.browseTabSelected,
              ),
              _buildBottomNavigationBarItem(
                index: 3,
                unselectedIconName: AppAssets.profileTab,
                selectedIconName: AppAssets.profileTab,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String unselectedIconName,
    required String selectedIconName,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage(unselectedIconName),
        color: selectedIndex == index
            ? AppColors.yellowPrimaryColor
            : AppColors.white,
      ),
      activeIcon: ImageIcon(
        AssetImage(selectedIconName),
        color: AppColors.yellowPrimaryColor,
      ),
      label: '',
    );
  }
}
