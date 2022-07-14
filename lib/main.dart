import 'package:corner_ar_gp/authentication/registration/registration_screen.dart';
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/login/LoginPage.dart';
import 'main_screens/home_screen/loading_screen.dart';


/** debug token D7C96657-48AD-422C-BEE2-49A12E387376  **/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppProvider(),
      builder: (context,widget) {
        final myAppProvider = Provider.of<AppProvider>(context);
        final isUserLoggedIn = myAppProvider.checkLoggedUser();

        if(isUserLoggedIn){
          myAppProvider.fetchLoggedUser();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            RegistrationScreen.routeName: (context) => RegistrationScreen(isAdmin: false),
            Login.routeName: (context) => Login(),
            LoadingScreen.routeName: (context) =>LoadingScreen(),
          },
          initialRoute: isUserLoggedIn?LoadingScreen.routeName:Login.routeName,
        );
      }
    );
  }
}
