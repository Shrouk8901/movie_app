import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/utils/ui_utils.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/data/models/auth/reset_password_request.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view_model/auth/auth_cubit.dart';
import 'package:movies_app/view_model/auth/auth_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showResetPasswordDialog(BuildContext context) {
  final resetFormKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool oldObsecure = true;
  bool newObsecure = true;

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color(0xFF1C1C1C),
            title: Center(
              child: Text(
                AppLocalizations.of(context)!.reset_password,
                style: TextStyle(
                  color: AppColors.yellowPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Form(
                key: resetFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.old_password,
                        labelStyle: TextStyle(color: AppColors.white),
                        prefixIcon:
                            Icon(Icons.lock_outline, color: AppColors.white),
                        filled: true,
                        fillColor: AppColors.semigrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              oldObsecure = !oldObsecure;
                            });
                          },
                          child: Icon(
                            oldObsecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      obscureText: oldObsecure,
                      style: TextStyle(color: AppColors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return Validators.validatePassword(value);
                      },
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.new_password,
                        labelStyle: TextStyle(color: AppColors.white),
                        prefixIcon: Icon(Icons.vpn_key, color: AppColors.white),
                        filled: true,
                        fillColor: Color(0xFF252525),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              newObsecure = !newObsecure;
                            });
                          },
                          child: Icon(
                            newObsecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      obscureText: newObsecure,
                      style: TextStyle(color: AppColors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return Validators.validatePassword(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ResetPasswordLoading) {
                    UIUtils.showLoading(context);
                  } else if (state is ResetPasswordError) {
                    UIUtils.hideLoading(context);
                    UIUtils.showMessage(state.message, context, AppColors.red);
                  } else if (state is ResetPasswordSuccess) {
                    UIUtils.hideLoading(context);
                    UIUtils.showMessage(
                        state.message, context, AppColors.green);
                    Navigator.of(context).pop();
                  }
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowPrimaryColor,
                    foregroundColor: AppColors.blackPrimaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    if (resetFormKey.currentState!.validate()) {
                      BlocProvider.of<AuthCubit>(context).resetPassword(
                          ResetPasswordRequest(
                              newPassword: newPasswordController.text,
                              oldPassword: oldPasswordController.text));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.reset),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
