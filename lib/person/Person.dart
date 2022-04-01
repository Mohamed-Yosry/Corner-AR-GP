import 'package:corner_ar_gp/database/DatabaseHelper.dart';
import 'package:corner_ar_gp/home_screen/admin_homescreen.dart';
import 'package:corner_ar_gp/person/Admin.dart';
import 'package:corner_ar_gp/person/User.dart' as app_user;
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/login/LoginPage.dart';
import '../home_screen/user_homescreen.dart';

class Person{
  late String name, email, id, lstName;
  var _errorMsg = null;

  Person({String name = '', String email = '', String id = ''}){
    this.name = name;
    this.email = email;
    this.id = id;
  }


  void setFirstName(String fName){
    this.name = fName;
  }
  void setLastName(String lName){
    lstName = lName;
  }
  void setEmail(String email){
    this.email = email;
  }

  Person.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name: json['name']! as String,
    email: json['email']! as String,
  );

  //to write in db
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'email' : email,
    };
  }

  Future<bool> registration(GlobalKey<FormState> formKey, String password, bool isAdmin, BuildContext context) async {
    print("is adddddmmmmmmmmmmmmmmmmmin $isAdmin");
    if(formKey.currentState?.validate() == true){
      final personRef = getPersonCollectionWithConverter(isAdmin? Admin.CollectionName :
                          app_user.User.CollectionName);
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        final AppProvider _myAppProvider =  Provider.of<AppProvider>(context, listen: false);
        id = userCredential.user!.uid;

        personRef.doc(id).set(
            Person(
              name: name + ' ' + lstName,
              email: email,
              id: id
            )
        ).then((user)async{
          _myAppProvider.updateLoggedUser(this);
          Navigator.pushReplacement<void, void>(
            context,
            isAdmin?MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  AdminHomeScreen(),
            ):MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  UserHomeScreen(),
            ),
          );
        });
        print('done --------------------------------------------------------------');
        return true;
      } on FirebaseAuthException catch (e) {
        _errorMsg = e;
        formKey.currentState?.validate();
      } catch (e) {
        // somethingWentWrong()
      }
    }
    return false;
  }

  Future<bool> logIn(GlobalKey<FormState> formKey, String password, BuildContext context) async{
    if(formKey.currentState?.validate() == true) {
      try {
        print("loooooged222222222222333333333");
        print(email);
        print(password);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password
        );
        if (userCredential.user == null) {
          print("invalid creditional no user exist with this email");
        } else {
          final AppProvider _myAppProvider =  Provider.of<AppProvider>(context, listen: false);
          //final db = FirebaseFirestore.instance;
          final adminRefrence =
            await getPersonCollectionWithConverter(Admin.CollectionName).doc(userCredential.user!.uid).get();

          final userRef = await getPersonCollectionWithConverter(adminRefrence.exists? Admin.CollectionName :
          app_user.User.CollectionName)
              .doc(userCredential.user!.uid)
              .get()
              .then((retrievedUser) async{
                email = await retrievedUser.data()!.email;
                id = await retrievedUser.data()!.id;
                name = await retrievedUser.data()!.name;

                _myAppProvider.updateLoggedUser(this);

                Navigator.pushReplacement<void, void>(
                  context,
                  adminRefrence.exists?MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        AdminHomeScreen(),
                  ):MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        UserHomeScreen(),
                  ),
                );
              });
        }
        print("loooooged222222222222");
      } on FirebaseAuthException catch (e) {
        _errorMsg = e;
        formKey.currentState?.validate();
      } catch (e) {
        print(e);
        print("errrrrrrrrrrrrrrrrrrorr");
      }
    }
    return false;
  }

  Future<void> logOut(context) async{
    print("logggggoutttttttttttperson");
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, Login.routeName);
  }

  /*void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }*/

  String? mailValidator([String? value])
  {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }else if(_errorMsg != null) {
      if(_errorMsg.code != 'weak-password' && _errorMsg.code != 'wrong-password') {
        if(_errorMsg.code == 'user-not-found') {
          _errorMsg = null;
          return 'No user found for that email.';
        }else {
          String msg = _errorMsg.message;
          _errorMsg = null;
          return msg;
        }
      }
    }
    return null;
  }

  String? passwordValidator([String? value]){
    if(value == null || value.isEmpty){
      return 'Please enter a password';
    }else if(_errorMsg != null){
      if(_errorMsg.code == 'weak-password' || _errorMsg.code == 'wrong-password') {
        if(_errorMsg.code == 'wrong-password'){
          _errorMsg = null;
          return 'The password provided for this account is wrong';
        }else {
          String msg = _errorMsg.message;
          _errorMsg = null;
          return msg;
        }
      }
    }
    return null;
  }

}




