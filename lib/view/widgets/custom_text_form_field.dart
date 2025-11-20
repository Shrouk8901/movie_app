import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      required this.image,
      required this.hint,
      this.isPassword = false,
      this.validator,
      this.controller,
      this.onChanged,
      this.keyboardType});

  final String image;
  final String hint;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObsecure = widget.isPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObsecure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.white,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: AppStyles.regular16white,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIconConstraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SvgPicture.asset(
            widget.image,
            width: 25,
            height: 25,
            fit: BoxFit.scaleDown,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObsecure = !isObsecure;
                  setState(() {});
                },
                icon: isObsecure
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility_outlined))
            : null,
      ),
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
