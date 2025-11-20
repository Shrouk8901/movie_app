import 'user_model.dart';

class UserDataResponse {
  final String message;
  final UserModel userModel;

  const UserDataResponse({required this.message, required this.userModel});

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      message: json['message'] as String,
      userModel: UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
