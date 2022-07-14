import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:corner_ar_gp/components/textField_components.dart';
import 'package:corner_ar_gp/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:corner_ar_gp/Furniture/Furniture.dart';
import 'package:corner_ar_gp/components/buttons_components.dart';
import 'package:file_picker/file_picker.dart';
import '../../Data/Data.dart';
import '../../components/getdata_components.dart';
import '../home_screen/admin_homescreen.dart';

class AddFurnitureScreen extends StatefulWidget {
  static const String title = "Add a Furniture";
  String categoryID;
  Data dataObject;

  AddFurnitureScreen({required this.categoryID,required this.dataObject});
  String? notNullValidator(String? value) => value == null || value.isEmpty ? "please enter a furniture name"
      : null;

  @override
  State<AddFurnitureScreen> createState() => _AddFurnitureScreenState();
}

class _AddFurnitureScreenState extends State<AddFurnitureScreen> {
  final formValidator = GlobalKey<FormState>();
  final Furniture _furniture = Furniture();
  late File modelFileBytes, modelPictureBytes;
  bool isModelPicked = false, isPicturePicked = false, firstScreenView = true, isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AddFurnitureScreen.title),
          backgroundColor: const Color(0xFFF87217),
        ),
        body: Stack(children: [
          Image.asset(
            'assets/backgroundTop.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  children: [
                    ElevatedButton(
                        onPressed: ()async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();

                          if (result != null) {
                            isModelPicked = true;
                            final appStorageDir = await getApplicationDocumentsDirectory();
                            File temp = File('${appStorageDir.path}/${result.files.first.name}');
                            modelFileBytes = File(result.files.first.path!);
                                modelFileBytes.copy(temp.path);
                          } else {
                            isModelPicked = false;
                          }
                        },
                        child: const Text(
                          "Pick a Furniture Model",
                          style: TextStyle(
                            color: Color(0xFFE56717)
                          )
                        ),
                      style:ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                    firstScreenView? const SizedBox(height: 0,):
                      isModelPicked? const SizedBox(height: 0,)
                        :const Text("please pick a furniture model", style: TextStyle(
                          color: Color.fromARGB(255, 211, 47, 47)),
                      ),

                    const SizedBox(height: 10,),

                    ElevatedButton(
                      onPressed: ()async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        );

                        if (result != null) {
                          isPicturePicked = true;
                          final appStorageDir = await getApplicationDocumentsDirectory();
                          File temp = File('${appStorageDir.path}/${result.files.first.name}');
                          modelPictureBytes = File(result.files.first.path!);
                          modelPictureBytes.copy(temp.path);
                        } else {
                          isPicturePicked = false;
                        }
                      },
                      child: const Text(
                        "Pick the Model Picture",
                          style: TextStyle(
                              color: Color(0xFFE56717)
                          )
                      ),
                      style:ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                    firstScreenView? const SizedBox(height: 0,)
                      : isPicturePicked? const SizedBox(height: 0,)
                          : const Text("please pick a furniture picture", style: TextStyle(
                        color: Color.fromARGB(255, 211, 47, 47)),
                    ),

                    const SizedBox(height: 10,),

                    Form(
                      key: formValidator,
                      child: textFormFieldComponent(
                        hintText: "Furniture Model Name",
                        validator: widget.notNullValidator,
                        isPasswordTextForm: false,
                        onChangedText: _furniture.setModelName
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 120),
                  child: isLoading? const Center(child: CircularProgressIndicator(),):
                  LogAndRegisterButton(
                      buttonText: "Add the Furniture",
                      onPressedButton: ()async {
                        setState(() {
                          firstScreenView = false;
                          isModelPicked;  isPicturePicked;

                          if(isModelPicked && isPicturePicked && formValidator.currentState!.validate()){
                            isLoading = true;
                          }
                        });

                        bool isSuccessful = false;
                        String snakeBarValue;
                        if(formValidator.currentState!.validate() && isModelPicked && isPicturePicked) {
                          isSuccessful = await uploadModel(widget.categoryID, _furniture, modelFileBytes, modelPictureBytes);
                          setState(() {
                            isLoading = false;
                            snakeBarValue = isSuccessful? "added successfully" : "failed to upload some error happend";
                          });
                          const snackBar = SnackBar(
                            content: Text('added successfully'),/// snakeBarValue
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          print("added successfully");

                          var furnitureData = await getDataFurniture("Furniture","Category");
                          widget.dataObject.furnitureData = furnitureData;
                          Navigator.pop(context);
                          Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) => AdminHomeScreen(2,"Furniture List",widget.dataObject)
                            )
                          );
                        }
                      }
                  )
              ),
            ],
          ),
        ])
    );
  }
}
