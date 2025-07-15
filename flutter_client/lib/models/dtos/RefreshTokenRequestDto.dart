class RefreshTokenRequestDto {
  final String userId;
  final String refreshToken;

  RefreshTokenRequestDto({
    required this.userId,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }
}