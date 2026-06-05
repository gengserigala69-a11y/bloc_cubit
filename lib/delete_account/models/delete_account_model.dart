class DeleteAccountModel {
  final bool success;
  final String message;
  final dynamic data;

  DeleteAccountModel({
    required this.success,
    required this.message,
    this.data,
  });

  DeleteAccountModel copyWith({
    bool? success,
    String? message,
    dynamic data,
  }) {
    return DeleteAccountModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory DeleteAccountModel.fromMap(Map<String, dynamic> json) {
    return DeleteAccountModel(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'success': success, 'message': message, 'data': data};
  }
}