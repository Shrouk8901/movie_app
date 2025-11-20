import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view/widgets/custom_text_form_field.dart';
import 'package:movies_app/view/widgets/custome_elevated_button.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.blackPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackPrimaryColor,
        title: Text(AppLocalizations.of(context)!.forgot_password),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image section
              SizedBox(
                height: screenHeight * 0.4,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/auth/Forgot_password.png', // Make sure this path exists
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * .04),

              // Form section
              Form(
                child: Column(
                  children: [
                    CustomTextFormField(
                      image: AppAssets.emailIcon, // Use your email icon asset
                      hint: AppLocalizations.of(context)!.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return Validators.validateEmail(value);
                      },
                    ),
                    SizedBox(height: screenHeight * .02),

                    // Verify Email Button
                    CustomeElevatedButton(
                      onPressed: () {
                        // Add your verify email logic here
                        Navigator.of(context).pop();
                      },
                      label: "Verify Email",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
