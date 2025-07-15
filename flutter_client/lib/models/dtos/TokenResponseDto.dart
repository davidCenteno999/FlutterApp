class TokenResponseDto {
  final String accessToken;
  final String refreshToken;

  TokenResponseDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenResponseDto.fromJson(Map<String, dynamic> json) {
    return TokenResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}