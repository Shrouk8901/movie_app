import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/core/routes/app_routes.dart';
import 'package:movies_app/core/utils/ui_utils.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/data/models/auth/register_request.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view/widgets/auth/carousel_avatares.dart';
import 'package:movies_app/view/widgets/auth/toggle_switch_language.dart';
import 'package:movies_app/view/widgets/custom_text_form_field.dart';
import 'package:movies_app/view/widgets/custome_elevated_button.dart';
import 'package:movies_app/view_model/auth/auth_cubit.dart';
import 'package:movies_app/view_model/auth/auth_states.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key,});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int currentAvatar = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * .17,
                width: double.infinity,
                child: CarouselAvatares(
                  onPageChanged: (index, _) {
                    if (currentAvatar == index) return;
                    currentAvatar = index;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: screenSize.height * .557,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextFormField(
                        image: AppAssets.nameIcon,
                        hint: AppLocalizations.of(context)!.name,
                        controller: nameController,
                        validator: (value) {
                          return Validators.validateName(value);
                        },
                      ),
                      CustomTextFormField(
                        image: AppAssets.emailIcon,
                        hint: AppLocalizations.of(context)!.email,
                        controller: emailController,
                        validator: (value) {
                          return Validators.validateEmail(value);
                        },
                      ),
                      CustomTextFormField(
                        image: AppAssets.passwordIcon,
                        hint: AppLocalizations.of(context)!.password,
                        isPassword: true,
                        controller: passwordController,
                        validator: (value) {
                          return Validators.validatePassword(value);
                        },
                      ),
                      CustomTextFormField(
                        image: AppAssets.passwordIcon,
                        hint: AppLocalizations.of(context)!.confirm_password,
                        isPassword: true,
                        controller: confirmPasswordController,
                        validator: (value) {
                          return Validators.validateConfirmPassword(
                              value, passwordController.text);
                        },
                      ),
                      CustomTextFormField(
                        image: AppAssets.phoneIcon,
                        hint: AppLocalizations.of(context)!.phone_number,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          return Validators.validatePhone(value);
                        },
                      ),
                      BlocListener<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is RegisterLoading) {
                            UIUtils.showLoading(context);
                          } else if (state is RegisterError) {
                            UIUtils.hideLoading(context);
                            UIUtils.showMessage(
                                state.message, context, AppColors.red);
                          } else if (state is RegisterSuccess) {
                            UIUtils.hideLoading(context);
                            Navigator.of(context).pushReplacementNamed(
                                AppRoutes.loginScreenRoute);
                          }
                        },
                        child: CustomeElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<AuthCubit>(context).register(
                                    RegisterRequest(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                        phone: phoneController.text,
                                        avaterId: currentAvatar));
                              }
                            },
                            label:
                                AppLocalizations.of(context)!.create_account),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.have_account,
                    style: AppStyles.regular16Roboto
                        .copyWith(fontSize: 14, color: AppColors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.loginScreenRoute);
                      },
                      child: Text(AppLocalizations.of(context)!.login,
                          style:
                              AppStyles.regular16Roboto.copyWith(fontSize: 14)))
                ],
              ),
              ToggleSwitchLanguage(
              ),
            ],
          ),
        ),
      ),
    );
  }
}
