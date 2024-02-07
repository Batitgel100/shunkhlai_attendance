class EmployeeDataEntity {
  final int id;
  final String? name;
  final int userId;
  final String? jobTitle;
  final String? mobilePhone;
  final String? workEmail;
  final int? companyId;
  final String? image1920;
  final String? workLocation;

  EmployeeDataEntity({
    required this.id,
    required this.name,
    required this.userId,
    required this.jobTitle,
    required this.mobilePhone,
    required this.workEmail,
    required this.companyId,
    required this.image1920,
    required this.workLocation,
  });

  factory EmployeeDataEntity.fromJson(Map<String, dynamic> json) {
    return EmployeeDataEntity(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      jobTitle: json['job_title'],
      mobilePhone: json['mobile_phone'],
      workEmail: json['work_email'],
      companyId: json['company_id'],
      image1920: json['image_1920'],
      workLocation: json['work_location'],
    );
  }
}
