import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corner_ar_gp/database/DatabaseHelper.dart';
import 'package:corner_ar_gp/person/Admin.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:corner_ar_gp/person/User.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
   Person? loggedUser;
   bool? _isAdmin;

  bool checkLoggedUser(){
    final firebaseCurrentUser = FirebaseAuth.instance.currentUser;
    return firebaseCurrentUser != null;
  }

  Future<void> fetchLoggedUser() async {
    final firebaseCurrentUser = FirebaseAuth.instance.currentUser;
    if (firebaseCurrentUser != null) {
      String _collectionName = app_user.User.CollectionName;
      await _checkAdmin(firebaseCurrentUser.uid).then((value){
        value? _collectionName = Admin.CollectionName : _collectionName;
        _isAdmin = value;
        }
      );
      print(_collectionName);
      _fetchUsers(_collectionName, firebaseCurrentUser).then((value) => loggedUser = value);
    }
  }

  Future<Person> _fetchUsers(String collectionName, firebaseCurrentUser) async {
    Person collectionPerson = Person();
     await getPersonCollectionWithConverter(collectionName)
        .doc(firebaseCurrentUser.uid)
        .get()
        .then((user) {
          if (user.data() != null) {
            collectionPerson = collectionName == Admin.CollectionName? Admin() : app_user.User();
            collectionPerson = user.data()!;
          }
        });
    return collectionPerson;
  }

  void updateLoggedUser(Person user) {
    loggedUser = user;
    notifyListeners();
  }

  Person getLoggedUser(){
    return loggedUser ?? Person();
  }

  Future<bool> _checkAdmin(String id)  async{
    final adminReference = await getPersonCollectionWithConverter(Admin.CollectionName).doc(id).get();
    FirebaseFirestore.instance
        .collection(Admin.CollectionName)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
          print("checking  ${value.size}");
      },
    );
    return adminReference.exists;
  }

  Future<bool> isLoggedUserAdmin() async {
    while(_isAdmin == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return _isAdmin ?? false;
  }
}
