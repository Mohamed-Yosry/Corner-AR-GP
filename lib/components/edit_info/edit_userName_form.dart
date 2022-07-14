import 'package:corner_ar_gp/components/textField_components.dart';
import 'package:flutter/cupertino.dart';

Container EditUserNameForm({
  required GlobalKey<FormState> formKey,
  required Function nameReturner,
  required Function lastNameReturner,
  String? firstNameSavedValue,
  String? lastNameSavedValue,
})
{
  _defaultValidator (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid name';
    }
    return null;
  }

  return Container(
    padding: const EdgeInsets.only(top: 8, right: 18, left: 14, bottom: 10),
    child: Form(
      key: formKey,
      child: Column(
        children: [
          textFormFieldComponent(
              hintText: 'First Name',
              onChangedText: (value) => nameReturner(value),
              validator: _defaultValidator,
              isPasswordTextForm: false,
              initialValue: firstNameSavedValue
          ),
          const SizedBox(height: 5,),
          textFormFieldComponent(
              hintText: 'Last Name',
              onChangedText: lastNameReturner,
              validator: _defaultValidator,
              isPasswordTextForm: false,
              initialValue: lastNameSavedValue
          ),
          const SizedBox(height: 5,),
        ],
      ),
    ),
  );
}