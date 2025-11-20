import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/core/routes/app_routes.dart';
import 'package:movies_app/core/utils/ui_utils.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/data/models/user_profile/update_user_profile_request.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view/screens/update_profile/reset_password_dialog.dart';
import 'package:movies_app/view/widgets/custom_text_form_field.dart';
import 'package:movies_app/view/widgets/custome_elevated_button.dart';
import 'package:movies_app/view_model/profile/profile_cubit.dart';
import 'package:movies_app/view_model/profile/profile_states.dart';
import '../../../core/constants/styles/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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

  late int currentAvatar;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final _updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = context.read<ProfileCubit>().user!.name;
    phoneController.text =
        context.read<ProfileCubit>().user!.phone.replaceFirst("+2", "");
    currentAvatar = context.read<ProfileCubit>().user!.avaterId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.blackPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackPrimaryColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.pick_avatar,
          style: AppStyles.regular16white
              .copyWith(color: AppColors.yellowPrimaryColor, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 37.h,
          ),
          GestureDetector(
            onTap: () async {
              final selected = await bottomSheet(context);
              if (selected != null) {
                currentAvatar = selected;
                setState(() {});
              }
            },
            child: Center(
              child: Image.asset(
                avatars[currentAvatar],
                height: 150.h,
                width: 150.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Form(
                key: _updateFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BlocBuilder<ProfileCubit, ProfileStates>(
                      builder: (context, state) {
                        if (state is UpdateProfileSuccess) {
                          nameController.text =
                              context.read<ProfileCubit>().user!.name;
                        }
                        return CustomTextFormField(
                          controller: nameController,
                          image: AppAssets.nameIcon,
                          hint: '',
                          validator: (value) {
                            return Validators.validateName(value);
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 19.28.h,
                    ),
                    BlocBuilder<ProfileCubit, ProfileStates>(
                      builder: (context, state) {
                        if (state is UpdateProfileSuccess) {
                          phoneController.text = context
                              .read<ProfileCubit>()
                              .user!
                              .phone
                              .replaceFirst("+2", "");
                        }
                        return CustomTextFormField(
                          controller: phoneController,
                          image: AppAssets.phoneIcon,
                          hint: '',
                          validator: (value) {
                            return Validators.validatePhone(value);
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    TextButton(
                      onPressed: () => showResetPasswordDialog(
                        context,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.reset_password,
                        style: AppStyles.regular16white.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    BlocListener<ProfileCubit, ProfileStates>(
                      listener: (context, state) {
                        if (state is DeleteProfileLoading) {
                          UIUtils.showLoading(context);
                        } else if (state is DeleteProfileError) {
                          UIUtils.hideLoading(context);
                          UIUtils.showMessage(
                              state.message, context, AppColors.red);
                        } else if (state is DeleteProfileSuccess) {
                          UIUtils.hideLoading(context);
                          Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.loginScreenRoute);
                        }
                      },
                      child: CustomeElevatedButton(
                        label: AppLocalizations.of(context)!.delete_account,
                        backGrounColor: AppColors.red,
                        labelColor: AppColors.white,
                        onPressed: () {
                          showDeleteAccountDialog(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    BlocListener<ProfileCubit, ProfileStates>(
                      listener: (context, state) {
                        if (state is UpdateProfileLoading) {
                          UIUtils.showLoading(context);
                        } else if (state is UpdateProfileError) {
                          UIUtils.hideLoading(context);
                          UIUtils.showMessage(
                              state.message, context, AppColors.red);
                        } else if (state is UpdateProfileSuccess) {
                          UIUtils.hideLoading(context);
                          UIUtils.showMessage(state.message, context,
                              AppColors.yellowPrimaryColor);
                          Navigator.of(context).pop();
                        }
                      },
                      child: CustomeElevatedButton(
                        label: AppLocalizations.of(context)!.update_data,
                        onPressed: () async {
                          if (_updateFormKey.currentState!.validate()) {
                            BlocProvider.of<ProfileCubit>(context)
                                .updateProfile(UpdateUserProfileRequest(
                                    avatarId: currentAvatar,
                                    name: nameController.text,
                                    phone: phoneController.text));
                          }
                        },
                        labelColor: AppColors.blackPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 33.h,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<int?> bottomSheet(BuildContext context) {
    return showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(14.0.w),
          child: Container(
            padding: EdgeInsets.all(16.w),
            height: MediaQuery.of(context).size.height * .42,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: GridView.builder(
              itemCount: avatars.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 19,
                crossAxisSpacing: 18,
              ),
              itemBuilder: (context, index) {
                final isSelected = index == currentAvatar;
                return InkWell(
                  onTap: () => Navigator.of(ctx).pop(index),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: isSelected
                          ? AppColors.yellowPrimaryColor
                          : Colors.transparent,
                      border: Border.all(color: AppColors.yellowPrimaryColor),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(avatars[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> showDeleteAccountDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(),
            child: AlertDialog(
              backgroundColor: AppColors.boldgrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Center(
                child: Text(
                  AppLocalizations.of(context)!.delete_account,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning,
                      size: 50.sp, color: AppColors.yellowPrimaryColor),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.delete_account_confirmation,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    BlocProvider.of<ProfileCubit>(context).deleteProfile();
                  },
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }
}
