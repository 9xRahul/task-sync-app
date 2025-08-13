class UserModel {
  String? id;
  String? name;
  String? email;
  bool? isVerified;

  UserModel({this.id, this.name, this.email, this.isVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['isVerified'] = this.isVerified;
    return data;
  }
}
