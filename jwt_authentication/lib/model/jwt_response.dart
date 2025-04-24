class JwtResponse {
  String token;
	String type;
	String refreshToken;
	String status;
	int candidateId;

  JwtResponse({
    required this.token, 
    required this.type, 
    required this.refreshToken,
    required this.status,
    required this.candidateId
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      token: json['token'],
      type: json['type'],
      refreshToken: json['refreshToken'],
      status: json['status'],
      candidateId: json['candidateId'],
    );
  }
}