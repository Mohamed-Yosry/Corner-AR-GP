import 'package:flutter/material.dart';

DropdownButton<String> categoryDropDownList({
  required String dropdownValue,
  required Function onPressedButton,
  required List<String> categoryList,
}){
  return  DropdownButton<String>(
    value: dropdownValue,
    isExpanded: true,
    icon: Align(child: const Icon(Icons.arrow_downward),alignment: Alignment.topRight,),
    style: const TextStyle(color: Colors.white,fontSize: 17),
    underline: Container(
      height: 2,
      color: const Color(0xFF4F6E7B),
    ),
     dropdownColor: const Color(0xFF4F6E7B),
     onChanged: (String? newValue)async {await onPressedButton(newValue);},
    items: categoryList//<String>['One', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}