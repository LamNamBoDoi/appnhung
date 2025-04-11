class Device {
  String? id;
  String? device_name;
  String? device_dep;
  String? device_uid;
  String? device_date;
  String? device_mode;

  Device(
      {this.id,
      this.device_name,
      this.device_dep,
      this.device_uid,
      this.device_date,
      this.device_mode});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      device_name: json['device_name'],
      device_dep: json['device_dep'],
      device_uid: json['device_uid'],
      device_date: json['device_date'],
      device_mode: json['device_mode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': device_name,
      'device_dep': device_dep,
      'device_uid': device_uid,
      'device_date': id,
      'device_mode': device_mode,
    };
  }
}
