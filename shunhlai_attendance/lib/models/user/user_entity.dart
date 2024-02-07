// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserViewEntity with ChangeNotifier {
//   Future<bool> saveUser(UserEntity user) async {
//     final SharedPreferences sp = await SharedPreferences.getInstance();
//     sp.setString('id', user.id.toString());
//     notifyListeners();
//     return true;
//   }

//   Future<UserEntity> getUser() async {
//     final SharedPreferences sp = await SharedPreferences.getInstance();
//     final String? id = sp.getString('id');

//     return UserEntity(id: id.toString());
//   }

//   Future<bool> remove() async {
//     final SharedPreferences sp = await SharedPreferences.getInstance();
//     sp.remove('id');
//     return true;
//   }
// }

class UserEntity {
  String? id;
  UserEntity({this.id});

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }
}
