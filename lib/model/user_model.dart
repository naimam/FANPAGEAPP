import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  String? registerDate;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.registerDate,
  });
  // getting data from server

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      role: map['role'],
      registerDate: map['registerDate'],
    );
  }

  //sending data to firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'registerDate': registerDate,
    };
  }
}
