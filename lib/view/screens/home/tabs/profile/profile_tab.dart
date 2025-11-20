import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/core/routes/app_routes.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/core/utils/ui_utils.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';
import 'package:movies_app/view/widgets/custome_elevated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/view/widgets/movies/fav_history_movies.dart';
import 'package:movies_app/view_model/profile/profile_cubit.dart';
import 'package:movies_app/view_model/profile/profile_states.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final List<String> avatars = const [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
  ];

  List<MovieBasicInfo> favMovies = [];
  List<MovieBasicInfo> recentMovies = [];
  int avatarId = 0;
  String name = '';

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    if (cubit.user == null) {
      cubit.getProfileWithMovies();
    }
    if (cubit.user != null) {
      favMovies = cubit.favMovies;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey2,
      padding: EdgeInsets.only(top: 52.h),
      child: DefaultTabController(
        length: 2,
        child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {
            if (state is GetProfileLoading ||
                state is RecentMoviesLoading ||
                state is GetFavMoviesLoading) {
              UIUtils.showLoading(context);
            } else if (state is GetProfileError) {
              UIUtils.hideLoading(context);
              UIUtils.showMessage(state.message, context, AppColors.red);
            } else if (state is RecentMoviesError) {
              UIUtils.hideLoading(context);
              UIUtils.showMessage(state.message, context, AppColors.red);
            } else if (state is GetFavMoviesError) {
              UIUtils.hideLoading(context);
              UIUtils.showMessage(state.message, context, AppColors.red);
            } else if (state is GetProfileSuccess ||
                state is GetFavMoviesSuccess ||
                state is RecentMoviesSuccess) {
              UIUtils.hideLoading(context);
            }
          },
          builder: (context, state) {
            if (context.read<ProfileCubit>().user != null &&
                (state is GetFavMoviesSuccess ||
                    state is GetProfileSuccess ||
                    state is UpdateProfileSuccess ||
                    state is RecentMoviesSuccess)) {
              avatarId = context.read<ProfileCubit>().user!.avaterId;
              name = context.read<ProfileCubit>().user!.name;
              favMovies = context.read<ProfileCubit>().favMovies;
              recentMovies = context.read<ProfileCubit>().historyMovies;
            }
            final safeIndex = (avatarId).clamp(0, avatars.length - 1);

            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: .4.sw,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlocBuilder<ProfileCubit, ProfileStates>(
                                      builder: (context, state) {
                                        if (state is GetProfileLoading) {
                                          return const SizedBox.shrink();
                                        } else {
                                          return Visibility(
                                            visible: context
                                                    .read<ProfileCubit>()
                                                    .user !=
                                                null,
                                            child: Image.asset(
                                              avatars[safeIndex],
                                              height: 118.h,
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(name, style: AppStyles.bold20white),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${favMovies.length}',
                                style: AppStyles.bold20white
                                    .copyWith(fontSize: 32.sp),
                              ),
                              SizedBox(height: 20.h),
                              Text(AppLocalizations.of(context)!.wish_list,
                                  style: AppStyles.bold20white
                                      .copyWith(fontSize: 22.sp)),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${recentMovies.length}',
                                style: AppStyles.bold20white
                                    .copyWith(fontSize: 32.sp),
                              ),
                              SizedBox(height: 20.h),
                              Text(AppLocalizations.of(context)!.history,
                                  style: AppStyles.bold20white
                                      .copyWith(fontSize: 22.sp)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 23.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Row(
                        children: [
                          CustomeElevatedButton(
                            label: AppLocalizations.of(context)!.edit_profile,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.updateProfileScreenRoute);
                            },
                            width: 253.w,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                backgroundColor: AppColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fixedSize: Size(double.infinity, 56),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.boldgrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                      content: Text(
                                        AppLocalizations.of(context)!.sure_exit,
                                        style: AppStyles.bold20white,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            SystemNavigator.pop();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColors.red),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.exit,
                                            style: AppStyles.bold24Roboto,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel,
                                            style: AppStyles.regular16Roboto,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.exit,
                                      style: AppStyles.regular20white),
                                  SizedBox(width: 10.w),
                                  Icon(Icons.logout,
                                      color: AppColors.white, size: 20.sp),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 33.h)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabBarDelegate(
                      height: 91.h,
                      TabBar(
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        dividerColor: AppColors.transparent,
                        indicatorColor: AppColors.yellowPrimaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Column(
                            children: [
                              SvgPicture.asset(AppAssets.whishIcon,
                                  fit: BoxFit.scaleDown),
                              SizedBox(height: 10.h),
                              Text(AppLocalizations.of(context)!.wish_list,
                                  style: AppStyles.regular20white),
                            ],
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(AppAssets.historyIcon,
                                  fit: BoxFit.scaleDown),
                              SizedBox(height: 10.h),
                              Text(AppLocalizations.of(context)!.history,
                                  style: AppStyles.regular20white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 800.h,
                      child: TabBarView(
                        children: [
                          favMovies.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    AppAssets.emptyMovies,
                                    height: 124.h,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : FavOrHistoryMovies(
                                  movies: favMovies.reversed.toList(),
                                ),
                          recentMovies.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    AppAssets.emptyMovies,
                                    height: 124.h,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : FavOrHistoryMovies(movies: recentMovies),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final double height;

  _SliverTabBarDelegate(this._tabBar, {required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.grey2,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
