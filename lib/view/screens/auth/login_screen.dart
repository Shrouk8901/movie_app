import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/core/routes/app_routes.dart';
import 'package:movies_app/core/utils/ui_utils.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/data/models/auth/login_request.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view/widgets/auth/toggle_switch_language.dart';
import 'package:movies_app/view/widgets/custom_text_form_field.dart';
import 'package:movies_app/view/widgets/custome_elevated_button.dart';
import 'package:movies_app/view_model/auth/auth_cubit.dart';
import 'package:movies_app/view_model/auth/auth_states.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key,});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 50),
                Center(
                  child: Image.asset(
                    'assets/images/icons/appLogo.png',
                    height: MediaQuery.sizeOf(context).height * 0.12,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextFormField(
                    hint: AppLocalizations.of(context)!.email,
                    controller: emailController,
                    image: AppAssets.emailIcon,
                    validator: (value) {
                      return Validators.validateEmail(value);
                    },
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextFormField(
                    hint: AppLocalizations.of(context)!.password,
                    image: AppAssets.passwordIcon,
                    controller: passwordController,
                    validator: (value) {
                      return Validators.validatePassword(value);
                    },
                    isPassword: true,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.forgetPasswordScreenRoute);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgot_password,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.yellowPrimaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is LoginLoading) {
                          UIUtils.showLoading(context);
                        } else if (state is LoginError) {
                          UIUtils.hideLoading(context);
                          UIUtils.showMessage(
                              state.message, context, AppColors.red);
                        } else if (state is LoginSuccess) {
                          UIUtils.hideLoading(context);
                          Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.homeScreenRoute);
                        }
                      },
                      child: CustomeElevatedButton(
                          label: AppLocalizations.of(context)!.login,
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              BlocProvider.of<AuthCubit>(context).login(
                                  LoginRequest(
                                      email: emailController.text,
                                      password: passwordController.text));
                            }
                          }),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dont_have_account,
                      style: TextStyle(color: AppColors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.registerScreenRoute);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.create_one,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.yellowPrimaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.yellowPrimaryColor,
                        thickness: 1,
                        indent: 50,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.or,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: AppColors.yellowPrimaryColor),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.yellowPrimaryColor,
                        thickness: 1,
                        indent: 10,
                        endIndent: 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: AppColors.yellowPrimaryColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.googleIcon),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          AppLocalizations.of(context)!.login_with_google,
                          style: AppStyles.regular16Roboto.copyWith(
                            color: AppColors.blackPrimaryColor,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ToggleSwitchLanguage(
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
