import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corner_ar_gp/Category/Category.dart';
import 'package:flutter/material.dart';

import '../../Data/Data.dart';
import '../../components/buttons_components.dart';
import '../../components/textField_components.dart';

class AddCategoryPage extends StatefulWidget {
  String title;
  Data dataObject;
  AddCategoryPage(this.title,this.dataObject);
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState(title);
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final validator = GlobalKey<FormState>();
  String title;
  Category category = Category();
  _AddCategoryPageState(this.title);
  bool isLoading = false;

  void setIsLoading(value){
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color(0xFFF87217),
        ),
        body: Stack(children: [
          Image.asset(
            'assets/backgroundTop.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 12),
            child: Form(
              key: validator,
              child: textFormFieldComponent(
                hintText: "Category name",
                isPasswordTextForm: false,
                validator: category.categroyValidator,
                onChangedText: category.setName
              ),
            ),
          ),
          Center(
            child: Container(
                child: LogAndRegisterButton(
                    buttonText: "Add Category",
                    onPressedButton:  ()=>category.addCategory(context, validator, (value)=>setIsLoading(value),widget.dataObject)
                )
            ),
          ),
          if (isLoading) const Center(
            child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
          ),
        ])
    );
  }
}
