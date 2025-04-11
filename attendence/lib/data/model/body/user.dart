class User {
  String? id;
  String? username;
  String? serialnumber;
  String? gender;
  String? email;
  String? card_uid;
  String? card_select;
  String? user_date;
  String? device_uid;
  String? device_dep;
  String? add_card;

  User(
      {this.id,
      this.username,
      this.serialnumber,
      this.gender,
      this.email,
      this.card_uid,
      this.card_select,
      this.user_date,
      this.device_uid,
      this.device_dep,
      this.add_card});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      serialnumber: json['serialnumber'],
      gender: json['gender'],
      email: json['email'],
      card_uid: json['card_uid'],
      card_select: json['card_select'],
      user_date: json['user_date'],
      device_uid: json['device_uid'],
      device_dep: json['device_dep'],
      add_card: json['add_card'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'serialnumber': serialnumber,
      'gender': gender,
      'email': email,
      'card_uid': card_uid,
      'card_select': card_select,
      'user_date': user_date,
      'device_uid': device_uid,
      'device_dep': device_dep,
      'add_card': add_card,
    };
  }
}
