import 'package:camera/camera.dart';
import 'package:corner_ar_gp/components/getdata_components.dart';
import 'package:corner_ar_gp/database/DatabaseHelper.dart';
import 'package:corner_ar_gp/main_screens/home_screen/admin_homescreen.dart';
import 'package:corner_ar_gp/main_screens/home_screen/user_homescreen.dart';
import 'package:corner_ar_gp/person/Admin.dart';
import 'package:corner_ar_gp/person/User.dart' as app_user;
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ColorDetection/Camera/camera.dart';
import '../Data/Data.dart';
import '../authentication/login/LoginPage.dart';
import '../main_screens/list_page/ListPage.dart';

class Person{
  late String name, email, id, lstName = '';
  var _errorMsg = null;
  List<CameraDescription> cameras = [];

  Person({String name = '', String email = '', String id = ''}){
    this.name = name;
    this.email = email;
    this.id = id;
  }

  Future setCamera() async{
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    return cameras;
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
  void setPerson(Person person)
  {
    this.email = person.email;
    this.name = person.email;
    this.id = person.id;
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

  Future<bool> registration(GlobalKey<FormState> formKey, String password,bool isAdmin,BuildContext context,Function isLoading) async {
    isLoading(true);
    if(formKey.currentState?.validate() == true){
      final personRef = getPersonCollectionWithConverter(isAdmin? Admin.CollectionName :
                          app_user.User.CollectionName);
      name = name + ' ' + lstName;
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        final AppProvider _myAppProvider =  Provider.of<AppProvider>(context, listen: false);
        id = userCredential.user!.uid;

        personRef.doc(id).set(
            Person(
              name: name,
              email: email,
              id: id
            )
        ).then((user)async{
          _myAppProvider.updateLoggedUser(this);

          late Widget nextPage;
          if(isAdmin){
            var adminData = await getData("Admin");
            var categoryData = await getData("Category");
            var furnitureData = await getDataFurniture("Furniture","Category");
            Data dataObject = Data(adminData, categoryData, furnitureData);
            nextPage = AdminHomeScreen(0,"Admins List",dataObject);
          }else if(!isAdmin){
            cameras = await setCamera();
            nextPage = Camera(cameras);
          }

          Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => nextPage,
              )
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
    isLoading(false);
    return false;
  }

  Future<bool> logIn(GlobalKey<FormState> formKey, String password, BuildContext context,Function isLoading) async{
    isLoading(true);
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

                late Widget nextPage;
                if(adminRefrence.exists){
                  var adminData = await getData("Admin");
                  var categoryData = await getData("Category");
                  var furnitureData = await getDataFurniture("Furniture","Category");
                  Data dataObject = Data(adminData, categoryData, furnitureData);
                  nextPage = AdminHomeScreen(0,"Admins List",dataObject);
                }else if(!adminRefrence.exists){
                  cameras = await setCamera();
                  nextPage = Camera(cameras);
                }

                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => nextPage,
                  )
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
    isLoading(false);
    return false;
  }

  Future<void> logOut(context) async{
    print("logggggoutttttttttttperson");
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, Login.routeName);
  }

  Future<bool> updateName(GlobalKey<FormState> formKey, String newName, String lastName, BuildContext context) async {
    bool returnState = false;
    if(formKey.currentState?.validate() == true) {
      print('uupddaattiinngg nnaammee');
      newName += ' ' + lastName;
      print(newName + ' ______________________________________');
      print('-------------------------------' + id);

      final adminReference = await getPersonCollectionWithConverter(
          Admin.CollectionName).doc(id).get();
      print('after ref');
      final userRef = getPersonCollectionWithConverter(
          adminReference.exists ? Admin.CollectionName :
          app_user.User.CollectionName);

      print('wait');
      await userRef.doc(id)
          .update({'name': newName})
          .then((value){
        name = newName;
        final AppProvider _myAppProvider =  Provider.of<AppProvider>(context, listen: false);
        _myAppProvider.updateLoggedUser(this);
        returnState = true;
      })
          .catchError((error){
        _errorMsg = error;
        formKey.currentState?.validate();
        print("name can't be changed" + error.toString());
        returnState =  false;
      });
    }
    print("================> $returnState <=========================");
    return returnState;
  }

  Future<bool> updateEmail(GlobalKey<FormState> formKey, String newEmail, String currentPassword, BuildContext context) async {
    bool returnState = false;
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _errorMsg = e;
      formKey.currentState?.validate();
      return false;
    }

    final adminReference = await getPersonCollectionWithConverter(
        Admin.CollectionName).doc(id).get();
    final userRef = getPersonCollectionWithConverter(
        adminReference.exists ? Admin.CollectionName :
        app_user.User.CollectionName);

    await userRef.doc(id)
        .update({'email': newEmail})
        .then((value) => print("User Updated"))
        .catchError((error){
      _errorMsg = error;
      formKey.currentState?.validate();
      print("Email can't be changed" + error.toString());
      return false;
    });

    print('uupddaattiinngg emaillllllllll');
    print('-------------------------------' + id);

    var user = FirebaseAuth.instance.currentUser;
    await user?.updateEmail(newEmail).then((_) {
      final AppProvider _myAppProvider =  Provider.of<AppProvider>(context, listen: false);
      _myAppProvider.updateLoggedUser(this);
      print("============>Successfully changed Email to :- $newEmail");
      returnState = true;
    }).catchError((error) {
      _errorMsg = error;
      formKey.currentState?.validate();
      print("Email can't be changed" + error.toString());
    });

    print("================> $returnState <=========================");
    return returnState;
  }

  Future<bool> updatePassword(GlobalKey<FormState> formKey, String currentPassword, String newerPassword) async {
    bool returnState = false;
    if (formKey.currentState?.validate() == true) {
      print('hello');
      print(currentPassword);
      print(newerPassword);
      try {
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
        await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
        print('passwordCorrect');
      } on FirebaseAuthException catch (e) {
        _errorMsg = e;
        formKey.currentState?.validate();
        print('current password not correct');
        print(e.message);
        return false;
      }
      var user = FirebaseAuth.instance.currentUser;

      await user?.updatePassword(newerPassword).then((_) {
        print("Successfully changed password");
        returnState = true;
      }).catchError((error) {
        _errorMsg = error;
        formKey.currentState?.validate();
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }
    return returnState;
  }

  Future<bool> deleteAccount(BuildContext context) async{
    bool isSuccess = true;

    final adminReference = await getPersonCollectionWithConverter(
        Admin.CollectionName).doc(id).get();
    final userRef = getPersonCollectionWithConverter(
        adminReference.exists ? Admin.CollectionName :
        app_user.User.CollectionName);

    await userRef.doc(id).delete().then(
            (doc) => print("Document deleted"),
        onError: (e) {
          print("Error updating document $e");
          isSuccess = false;
          return false;
        }
    );

    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
      isSuccess = false;
      return false;
    }

    final AppProvider _myAppProvider =  Provider.of<AppProvider>(context, listen: false);
    _myAppProvider.updateLoggedUser(Person());
    return isSuccess;
  }

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