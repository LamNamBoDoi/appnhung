class Admin {
  int? id;
  String? admin_name;
  String? admin_email;
  String? admin_pwd;

  Admin({
    this.id,
    this.admin_name,
    this.admin_email,
    this.admin_pwd,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      admin_name: json['admin_name'],
      admin_email: json['admin_email'],
      admin_pwd: json['admin_pwd'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_name': admin_name,
      'admin_email': admin_email,
      'admin_pwd': admin_pwd
    };
  }
}
