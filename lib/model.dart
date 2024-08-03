class UserModel {
  String? email;
  String? wrool;
  String? uid;
  String? numeCopil;
  String? numeParinte;

// receiving data
  UserModel({this.uid, this.email, this.wrool, this.numeCopil, this.numeParinte});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      wrool: map['wrool'],
      numeCopil: map['numeCopil'],
      numeParinte: map['numeParinte'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'wrool': wrool,
      'numeCopil': numeCopil,
      'numeParinte': numeParinte,
    };
  }
}
