class ErrorDataModel {
  final String message;
  final int statusCode;
  const ErrorDataModel({required this.message, required this.statusCode});
  factory ErrorDataModel.fromJson(Map<String, dynamic> json) => ErrorDataModel(
    message: json["message"] ?? "",
    statusCode: json["statusCode"] ?? 500,
  );
}
