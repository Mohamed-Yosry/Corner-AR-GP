import 'package:corner_ar_gp/components/drawer_component.dart';
import 'package:corner_ar_gp/main_screens/edit_info/edit_person_info.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = 'userHomeScreen';

  UserHomeScreen();
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late Person loggedUser;
  late String sideMenuContent;
  int pageIndex = 0;


  @override
  Widget build(BuildContext context) {

    final _myAppProvider =  Provider.of<AppProvider>(context);
    loggedUser = _myAppProvider.getLoggedUser();
    sideMenuContent = loggedUser.name;


    return Scaffold(
      drawer: sideMenu(changeToEditPage: _setToEditPage, isAdmin: false,userName: sideMenuContent,buildContext:context,personObject: loggedUser),
      appBar: AppBar(
        title: Text("User"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/backgroundBottom.png',
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            child: Image.asset(
              'assets/backgroundTop.png',
              fit: BoxFit.fill,
              //height: double.infinity,
              width: double.infinity,
            ),
          ),
          pageIndex == 1 ? EditPersonInformation(loggedUser) : const SizedBox(height: 0,)
        ],
      )


    );
  }

  _setToEditPage()
  {
    setState(() {
      pageIndex = 1;
    });
  }
}