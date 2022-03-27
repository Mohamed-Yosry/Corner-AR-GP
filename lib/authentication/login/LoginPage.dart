import 'package:corner_ar_gp/authentication/registration/registration_screen.dart';
import 'package:corner_ar_gp/person/Admin.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:corner_ar_gp/person/User.dart';
import 'package:flutter/material.dart';
import '../../components/buttons_components.dart';
import '../../components/textField_components.dart';


class Login extends StatefulWidget {
  static const routeName = 'login';
  bool isAdmin;
  Login({this.isAdmin = false});
  @override
  _LoginState createState() => _LoginState(isAdmin);
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  Person person = Person();
  String password = '';
  bool isPasswordHidden = true, isAdmin;
  _LoginState(this.isAdmin){
    person = isAdmin? Admin() : User();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Container(
              padding: const EdgeInsets.fromLTRB(30, 170, 30, 12),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset('assets/logAndRegisterIcon.png'),
                            ),
                            const SizedBox(height: 70),
                            textFormFieldComponent(
                                hintText:"Email",
                                onChangedText: person.setEmail,
                                validator:  person.mailValidator
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isPasswordHidden? true : false,
                              onChanged: (newValue){
                                password=newValue;
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFbdc6cf)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFbdc6cf)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(isPasswordHidden?
                                  Icons.visibility_off_outlined:
                                  Icons.visibility_outlined,color: Color(0xFFbdc6cf),),
                                  onPressed: (){
                                    isPasswordHidden = !isPasswordHidden;
                                    setState(() {});
                                  },
                                ),

                              ),
                              validator: (value) => person.passwordValidator(value),
                              style: TextStyle(color: const Color(0xFFbdc6cf)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(70,80,70,0),
                        child: LogAndRegisterButton(
                            buttonText: "Log In",
                            onPressedButton:  ()=>person.logIn(_loginFormKey, password, isAdmin ,context)
                        ),
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {  },
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 50, 15, 12),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegistrationScreen.routeName);
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54
                              //color: Colors.white
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
          ],
        )
    );
  }
}
