class UpdateUserProfileRequest {
  final int avatarId;
  final String name;
  final String phone;

  UpdateUserProfileRequest(
      {required this.avatarId, required this.name, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      "avaterId": avatarId,
      "name": name,
      "phone": "+2$phone",
    };
  }
}
