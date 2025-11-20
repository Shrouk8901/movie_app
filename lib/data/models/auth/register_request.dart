class RegisterRequest {
  const RegisterRequest(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword,
      required this.phone,
      required this.avaterId});

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final num avaterId;

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "phone": "+2$phone",
        "avaterId": avaterId,
      };
}
