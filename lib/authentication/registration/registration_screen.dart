import 'package:corner_ar_gp/person/Admin.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:corner_ar_gp/person/User.dart';
import 'package:flutter/material.dart';

import '../../components/buttons_components.dart';
import '../../components/textField_components.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = 'registration';
  bool isAdmin;
  RegistrationScreen({this.isAdmin = false});
  @override
  _registrationScreenState createState() => _registrationScreenState(isAdmin);
}

class _registrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  Person person = Person();
  String password = '';
  bool isAdmin;
  bool isPasswordHidden = true;

  _registrationScreenState(this.isAdmin) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: Image.asset('assets/logAndRegisterIcon.png'),
                        ),
                        const SizedBox(height: 70),

                        textFormFieldComponent(
                            hintText:'First Name',
                            onChangedText: person.setFirstName,
                            validator:  (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 5),
                        textFormFieldComponent(
                            hintText:'Last Name',
                            onChangedText: person.setLastName,
                            validator:  (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                        ),

                        const SizedBox(height: 5),
                        textFormFieldComponent(
                          hintText:'Email Address',
                          onChangedText: person.setEmail,
                          validator:  person.mailValidator
                        ),

                        const SizedBox(height: 5),
                        TextFormField(
                          obscureText: isPasswordHidden? true : false,
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
                              Icons.visibility_outlined),
                              onPressed: (){
                                isPasswordHidden = !isPasswordHidden;
                                setState(() {});
                              },
                            ),
                          ),
                          onChanged: (value){
                            password = value;
                          },
                          validator: (value) => person.passwordValidator(value),
                          style: TextStyle(color: const Color(0xFFbdc6cf)),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(70,80,70,0),
                            child: LogAndRegisterButton(
                                buttonText: "Sign Up",
                                onPressedButton:  ()=>person.registration(_formKey, password, isAdmin)
                            )
                        ),

                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}
