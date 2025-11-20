class UserProfileResponse {
  final String message;

  const UserProfileResponse({required this.message});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      message: json['message'] as String,
    );
  }
}
