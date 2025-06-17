class OtpVerifyResponse {
  final String message;

  OtpVerifyResponse({required this.message});

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(message: json['message']);
  }
}
