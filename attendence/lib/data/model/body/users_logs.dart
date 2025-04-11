class UserLogs {
  String? id;
  String? username;
  String? serialnumber;
  String? timein;
  String? timeout;
  String? card_uid;
  String? checkindate;
  String? device_uid;
  String? device_dep;
  String? cardout;

  UserLogs(
      {this.id,
      this.username,
      this.serialnumber,
      this.timein,
      this.timeout,
      this.card_uid,
      this.checkindate,
      this.device_uid,
      this.device_dep,
      this.cardout});

  factory UserLogs.fromJson(Map<String, dynamic> json) {
    return UserLogs(
      id: json['id'],
      username: json['username'],
      serialnumber: json['serialnumber'],
      timein: json['timein'],
      timeout: json['timeout'],
      card_uid: json['card_uid'],
      checkindate: json['checkindate'],
      device_uid: json['device_uid'],
      device_dep: json['device_dep'],
      cardout: json['cardout'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'serialnumber': serialnumber,
      'timein': timein,
      'timeout': timeout,
      'card_uid': card_uid,
      'checkindate': checkindate,
      'device_uid': device_uid,
      'device_dep': device_dep,
      'cardout': cardout,
    };
  }
}
