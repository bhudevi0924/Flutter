class Candidate {
  String name;
  String email;
  String phoneNo;
  String degree;
  String collegeName;
  String department;
  int graduationYear;
  double percentage;
  int genderId;
  int govtUIDTypeId;
  String govtUID;
  int testcodeId;
  bool currentlyWorking;

  Candidate({
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.degree,
    required this.collegeName,
    required this.department,
    required this.graduationYear,
    required this.percentage,
    required this.genderId,
    required this.govtUIDTypeId,
    required this.govtUID,
    required this.testcodeId,
    required this.currentlyWorking
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'degree': degree,
      'collegeName': collegeName,
      'department': department,
      'graduationYear': graduationYear,
      'percentage': percentage,
      'genderId': genderId,
      'govtUIDTypeId': govtUIDTypeId,
      'govtUID': govtUID,
      "testcodeId": testcodeId,
      "currentlyWorking":currentlyWorking
    };
  }
}
