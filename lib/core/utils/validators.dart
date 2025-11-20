class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length > 21) {
      return "Name must be at most 20 characters";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

static String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Password is required";
  }
  if (value.length < 8) {
    return "Password must be at least 8 characters";
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Password must contain at least one uppercase letter";
  }

    if (value.contains('-')) {
    return "Password must not contain '-' character";
  }

  if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return "Password must contain at least one special character";
  }



  return null;
}


  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone is required";
    }
    if (!RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(value)) {
      return "Enter a valid Egyptian phone number";
    }
    return null;
  }
}
