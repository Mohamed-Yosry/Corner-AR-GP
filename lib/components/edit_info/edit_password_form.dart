import 'package:corner_ar_gp/components/textField_components.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:flutter/cupertino.dart';

Container EditPasswordForm({
  required Person person,
  required Function passwordGetter,
  required Function newPasswordGetter,
  required Function currentPasswordValidator,
  required Function toggleCurrentPasswordVisibility,
  required Function toggleNewPasswordVisibility,
  required GlobalKey<FormState> formCurrentKey,
  required GlobalKey<FormState> passwordFormKey,
  String? newPassSavedValue,
  String? newConfirmationPassSavedValue,
  bool hideCurrentPassword = true,
  bool hideNewPassword = true
}){

  String? _password, _confirmedPassword;
  String? _validatePassword(String? value){
    return value!.length < 6 ? 'password length must be greater than 6' : null;
  }
  String? _validateConfirmedPassword(String? value){
    String? message;
    print('validating');
    if(_confirmedPassword != _password) {
      print(value??'*/*');print('different password');print( _password!);
      message = 'Password confirmation does not match the password';
    }
    if(value!.length < 6){
      print('small pass');
      message = 'password length must be greater than 6';
    }
    if(message == null){
      print('seems ture to me');
      newPasswordGetter(value);
    }
    return message;
  }

  void _setPassword(String pass){
    _password = pass;
  }

  return Container(
    padding: const EdgeInsets.only(top: 8, right: 18, left: 14, bottom: 10),
    child: Column(
      children: [
        Form(
          key: formCurrentKey,
          child: textFormFieldComponent(
              hintText: 'Current Password',
              onChangedText: (value) => passwordGetter(value),
              validator: currentPasswordValidator,
              isPasswordTextForm: true,
              isPasswordHidden: hideCurrentPassword,
              togglePasswordVisibility: toggleCurrentPasswordVisibility
          ),
        ),
        Form(
          key: passwordFormKey,
          child: Column(
            children: [
              const SizedBox(height: 5,),
              textFormFieldComponent(
                  hintText: 'New Password',
                  onChangedText: (value)=> _password = value,
                  validator: _validatePassword,
                  isPasswordTextForm: true,
                  isPasswordHidden: hideNewPassword,
                  togglePasswordVisibility: toggleNewPasswordVisibility,
                  initialValue: newPassSavedValue
              ),
              const SizedBox(height: 5,),
              textFormFieldComponent(
                  hintText: 'Confirm Password',
                  onChangedText: (value)=> _confirmedPassword= value,
                  validator: _validateConfirmedPassword,
                  isPasswordTextForm: true,
                  isPasswordHidden: hideNewPassword,
                  togglePasswordVisibility: toggleNewPasswordVisibility,
                  initialValue: newConfirmationPassSavedValue
              ),
              const SizedBox(height: 5,),
            ],
          ),
        ),
      ],
    ),
  );
}