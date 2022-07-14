import 'package:corner_ar_gp/authentication/registration/registration_screen.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:flutter/material.dart';
import '../../components/buttons_components.dart';
import '../../components/textField_components.dart';


class Login extends StatefulWidget {
  static const routeName = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  Person person = Person();
  String password = '';
  bool isPasswordHidden = true;
  bool isLoading =false;

  _LoginState();

  void setIsLoading(value){
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/background2.png',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 200, 30, 12),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            Image.asset('assets/logAndRegisterIcon.png'),
                            const SizedBox(height: 70),
                            textFormFieldComponent(
                                hintText:"Email address",
                                onChangedText: person.setEmail,
                                validator:  person.mailValidator,
                                isPasswordTextForm: false
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isPasswordHidden? true : false,
                              onChanged: (newValue){
                                password=newValue;
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFbdc6cf)),
                                ),
                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFbdc6cf)),),
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
                              style: const TextStyle(color:  Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(70,80,70,0),
                        child: LogAndRegisterButton(
                            buttonText: "Log In",
                            onPressedButton:  ()=>person.logIn(_loginFormKey, password,context,(value)=>setIsLoading(value))
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
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
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
            if (isLoading) const Center(
              child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
            ),
          ],
        )
    );
  }
}
