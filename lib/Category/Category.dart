import 'package:corner_ar_gp/main_screens/home_screen/admin_homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/Data.dart';
import '../components/getdata_components.dart';
import '../database/DatabaseHelper.dart';

class Category{
  static const collectionName = "Category";
  late String name,id;
  var data;
  Category({String name = '',String id = ''}){
    this.name = name;
    this.id = id;
  }

  void setName(String name){
    this.name = name;
  }
  void setId(String id){
    this.id = id;
  }

  String getName(){
    return name;
  }
  String getId(){
    return id;
  }

  Category.fromJson(Map<String, Object?> json)
      : this(
    name: json['name']! as String,
    id: json['id']! as String,
  );

  //to write in db
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  Future<void> addCategory(BuildContext context,GlobalKey<FormState> formKey,Function isLoading,Data dataObject) async {
    isLoading(true);
    data = dataObject.categoryData;
    if(formKey.currentState?.validate() ==false) {
      return;
    }
    final categoryRef = getCategoryCollectionWithConverter("Category");

    String temp = categoryRef.doc().id;

    try{
      categoryRef.doc(temp).set(
          Category(
              name: name,
              id: temp
          )
      ).then((value) async{
        data = await getData("Category");
        dataObject.categoryData = data;
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>AdminHomeScreen(1,"Categories List",dataObject)
            )
        );
      });
    } catch (e) {
      print("add category error:   $e");
    }
  }

  String? categroyValidator([String? value]){
    if (value == null || value.isEmpty) {
      return 'Please enter an Category name';
    }
    else{
      bool isExist = categoryExist(value);
      if(isExist) {
        return 'this Category name exist';
      }
    }
    return null;
  }

  bool categoryExist(String value) {
      for(int i=0;i<data.length;i++){
        if(value == data[i]['name']) {
          return true;
        }
      }
      return false;
  }
}