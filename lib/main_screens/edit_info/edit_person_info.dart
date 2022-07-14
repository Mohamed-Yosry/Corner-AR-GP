import 'package:corner_ar_gp/components/edit_info/edit_email_form.dart';
import 'package:corner_ar_gp/components/edit_info/edit_info_card.dart';
import 'package:corner_ar_gp/components/edit_info/edit_password_form.dart';
import 'package:corner_ar_gp/components/edit_info/edit_userName_form.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:flutter/material.dart';

import '../../authentication/login/LoginPage.dart';

class EditPersonInformation extends StatefulWidget {
  static const String routeName = 'editUsersInfo';
  Person loggedUser;
  EditPersonInformation(this.loggedUser, {Key? key}) : super(key: key);
  @override
  State<EditPersonInformation> createState() => _EditPersonInformationState();
}

class _EditPersonInformationState extends State<EditPersonInformation> {
  List<int> formsIconsStats = [0,0,0];
  late bool _editingUserName, _editingPassword, _editingEmail;
  bool hidePassword = true, hideNewPassword = true;
  bool _isApplyingChanges = false, _isDeleting = false;

  final _nameFormKey = GlobalKey<FormState>(), _passwordFormKey = GlobalKey<FormState>(),
  _currPassFormKey = GlobalKey<FormState>(), _emailFormKey = GlobalKey<FormState>();

  final PersonParamToEdit _infoParameter = PersonParamToEdit();

  void initState(){
    _editingUserName = false;
    _editingEmail = false;
    _editingPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    print('========================='+widget.loggedUser.id+'============================');


    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Account"),
          backgroundColor: Color(0xFFF87217),
        ),
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/backgroundTop.png',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Column(
            children :[
              Expanded(
                child: ListView(
                children: <Widget>[
                 const SizedBox(height: 25,),
                 TileEditCard(cardTitle: 'Edit Name', onTapFunction: _toggleEditNameOntTap, iconState: formsIconsStats[0]),
                 _editingUserName?
                    EditUserNameForm(
                        formKey: _nameFormKey,
                        nameReturner: _infoParameter.setNewName,
                        lastNameReturner: _infoParameter.setNameToFullName,
                        firstNameSavedValue: _infoParameter.getNewName(),
                        lastNameSavedValue: _infoParameter.getLastNameTemp()
                    )
                    : const SizedBox(height: 10,),
                 TileEditCard(cardTitle: 'Edit Password', onTapFunction: _toggleEditPasswordOntTap, iconState: formsIconsStats[1]),
                 _editingPassword?
                      EditPasswordForm(
                          person: widget.loggedUser,
                          passwordGetter: _infoParameter.setCurrPass,
                          newPasswordGetter: _infoParameter.setNewPass,
                          currentPasswordValidator: widget.loggedUser.passwordValidator,
                          hideCurrentPassword: hidePassword,
                          hideNewPassword: hideNewPassword,
                          formCurrentKey: _currPassFormKey,
                          passwordFormKey: _passwordFormKey,
                          toggleCurrentPasswordVisibility: _toggleCurrentPasswordVisibility,
                          toggleNewPasswordVisibility: _toggleNewEnteredPasswordVisibility,
                      )
                      : const SizedBox(height: 10,),
                 TileEditCard(cardTitle: 'Edit Email Address', onTapFunction: _toggleEditEmailOntTap, iconState: formsIconsStats[2]),
                 _editingEmail?
                     EditEmailForm(
                         formKey: _emailFormKey,
                         emailReturner: _infoParameter.setNewEmail,
                         passReturner: _infoParameter.setCurrPass,
                         emailValidator: widget.loggedUser.mailValidator,
                         passwordValidator: widget.loggedUser.passwordValidator,
                         togglePasswordVisibility: _toggleCurrentPasswordVisibility,
                         hidePassword: hidePassword,
                         emailSavedValue: _infoParameter.getNewMail()
                     ):const SizedBox(height: 0,),
                ],
            ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10,),
                        Expanded(
                            child: _isApplyingChanges?  const Center(child: CircularProgressIndicator(),):
                              ElevatedButton(
                                onPressed: () {
                                  print('*******'*5);
                                  EditValueParameters parameters = EditValueParameters(widget.loggedUser,
                                      _nameFormKey,
                                      _currPassFormKey,
                                      _passwordFormKey,
                                      _emailFormKey,
                                      _iconResponseToApplyChanges,
                                      _toggleApplyingChangesLoading,
                                      _isChangingPassword());
                                  _infoParameter.applyChanges(
                                      parameters,
                                      context);
                                },
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: const Color(0xFFF87217),
                                  fixedSize: const Size(200, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              )
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                            child: ElevatedButton(
                              onPressed: (){},
                              child: const Text(
                                'Delete Account',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                onPrimary: const Color(0xFFFCFCFC),
                                fixedSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            )
                        ),
                        const SizedBox(width: 10,),

                      ],
                    ),
                    const SizedBox(height: 30,),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  _toggleEditNameOntTap(){
    if(_infoParameter.getNewName()!=null || _infoParameter.getLastNameTemp()!=null){
      formsIconsStats[0]=1;
    }
    _hideAllPassword();
    setState(() {
      _editingUserName = !_editingUserName;
      _editingEmail = false;
      _editingPassword = false;
    });
  }
  _toggleEditPasswordOntTap(){
    if(!_infoParameter.doseCurrPassIsNull() && !_infoParameter.doseNewPassIsNull()){
      formsIconsStats[1]=1;
    }
    _hideAllPassword();
    setState(() {
      _editingUserName = false;
      _editingEmail = false;
      _editingPassword = !_editingPassword;
    });
  }
  _toggleEditEmailOntTap(){
    if(_infoParameter.getNewMail()!=null || !_infoParameter.doseCurrPassIsNull()){
      formsIconsStats[2]=1;
    }
    _hideAllPassword();
    setState(() {
      _editingUserName = false;
      _editingEmail = !_editingEmail;
      _editingPassword = false;
    });
  }

  _toggleCurrentPasswordVisibility()
  {
    setState(() {
      hidePassword = !hidePassword;
    });
  }
  _toggleNewEnteredPasswordVisibility()
  {
    setState(() {
      hideNewPassword = !hideNewPassword;
    });
  }

  _toggleApplyingChangesLoading(){
    setState(() {
      _isApplyingChanges = ! _isApplyingChanges;
    });
  }

  _toggleIsDeletingAccountLoading(){
    setState(() {
      _isDeleting = !_isDeleting;
    });
  }

  void _hideAllPassword(){
    hidePassword = true;
    hideNewPassword = true;
  }

  _iconResponseToApplyChanges(int index, int value){
    setState(() {
      formsIconsStats[index] = value;
    });
  }
  bool _isChangingPassword(){
    return !_infoParameter.doseConfirmedPassIsNull() || !_infoParameter.doseCurrPassIsNull() || !_infoParameter.doseNewPassIsNull();
  }
}

class PersonParamToEdit {
  String? _newName, _currPass, _newPass, _newToConfirmedPass, _newMail, _tempLastName;

  void setNewName(String? value){
    _newName = value;
  }
  void setNewEmail(String? value){
    _newMail = value;
  }
  void setCurrPass(String? value){
    _currPass = value;
  }
  void setNewPass(String? value){
    _newPass = value;
  }
  void setToConfirmPass(String? value){
    _newPass = value;
  }
  void setNameToFullName(String? value){
    _tempLastName = value;
  }

  String? getNewName() => _newName;
  String? getNewMail() => _newMail;
  String? getLastNameTemp() => _tempLastName;
  String? getNewPass() => _newPass;
  String? getNewConfirmedPass() => _newToConfirmedPass;

  bool doseCurrPassIsNull() => _currPass == null;
  bool doseNewPassIsNull() => _currPass == null;
  bool doseConfirmedPassIsNull() => _currPass == null;

  applyChanges(EditValueParameters params, BuildContext context) async {
    Person loggedUser = params.loggedUser;
    GlobalKey<FormState> nameFormKey = params.nameFormKey,
        passwordFormKey = params.passwordFormKey,
        currentPasswordFormKey = params.currentPasswordFormKey,
        emailFormKey = params.emailFormKey;

    print(">>>>>>>>>>>>>>>>>>>>>>> " +loggedUser.email + " <<<<<<<<<<<<<<<");
    if(nameFormKey.currentState?.validate()==true) {
      params.toggleLoading();
      print(_newName??'//');
      bool isSuccess = await loggedUser.updateName(
          nameFormKey, _newName ?? '',
          _tempLastName ?? '', context);

      if(isSuccess){
        _newName = null;
        _tempLastName = null;
        nameFormKey.currentState?.reset();
        params.iconResponse(0, 3);
      }
      else {
        params.iconResponse(0, 2);
      }

      params.toggleLoading();
    }

    if (currentPasswordFormKey.currentState?.validate() == true && passwordFormKey.currentState?.validate() == true) {
      params.toggleLoading();
      bool isSuccess = await loggedUser.updatePassword(
          currentPasswordFormKey, _currPass ?? '', _newPass ?? '');
      if(isSuccess){
        _currPass = null;
        _newPass = null;
        _newToConfirmedPass = null;
        currentPasswordFormKey.currentState?.reset();
        passwordFormKey.currentState?.reset();
        params.iconResponse(1, 3);
      } else {
        params.iconResponse(1, 2);
      }

      params.toggleLoading();
    }

    if(emailFormKey.currentState?.validate() == true) {
      params.toggleLoading();
      bool isSuccess = await loggedUser.updateEmail(
          emailFormKey, _newMail ?? '',
          _currPass ?? '', context);

      if(isSuccess){
        _newMail = null;
        emailFormKey.currentState?.reset();
        params.iconResponse(2, 3);
      } else {
        params.iconResponse(2, 2);
      }
      _currPass = null;
      params.toggleLoading();
    }
  }

  deleteUser(Person loggedUser, BuildContext context, Function isLoading) async{
    isLoading();
    bool isDeleted = await loggedUser.deleteAccount(context);
    if(isDeleted) {
      loggedUser = Person();
      Navigator.pop(context);
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>Login()
        ),
      );
    } else{
      isLoading();
      const snackBar = SnackBar(
        content: Text('cannot delete this account'),/// snakeBarValue
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //print("added successfully");
    }


  }

}

class EditValueParameters{
  Person _loggedUser;
  GlobalKey<FormState> _nameFormKey, _currentPasswordFormKey, _passwordFormKey, _emailFormKey;
  Function iconResponse, toggleLoading;
  bool _toChangingPassword;

  EditValueParameters(
      this._loggedUser,
      this._nameFormKey,
      this._currentPasswordFormKey,
      this._passwordFormKey,
      this._emailFormKey,
      this.iconResponse,
      this.toggleLoading,
      this._toChangingPassword);

  GlobalKey<FormState> get nameFormKey => _nameFormKey;

  get emailFormKey => _emailFormKey;

  get passwordFormKey => _passwordFormKey;

  get currentPasswordFormKey => _currentPasswordFormKey;

  bool get toChangingPassword => _toChangingPassword;

  Person get loggedUser => _loggedUser;
}