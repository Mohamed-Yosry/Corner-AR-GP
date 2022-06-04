import 'package:corner_ar_gp/components/buttons_components.dart';
import 'package:flutter/material.dart';
import '../main_screens/list_page/SavedFurntiureListPage.dart';
import '../person/Person.dart';
import 'getdata_components.dart';


Drawer sideMenu(
{
  required Function changeToEditPage,
  required bool isAdmin,
  required BuildContext buildContext,
  required Person personObject,
  required Function isLoading
}
    ){
  return Drawer(
    backgroundColor: const Color(0xFF71A2B5),
    child: Column(
      children: [
        DrawerHeader(
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/profile.png',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  personObject.name,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
        listMenuButtons(
            buttonName: 'Edit Profile',
            onPressedButton: (){changeToEditPage(); Navigator.pop(buildContext);}
        ),
        const SizedBox(height: 5,),
        //if user show saved furniture button
        isAdmin?Container(child:null):
        listMenuButtons(
            buttonName: 'Saved Furniture',
            onPressedButton: () async {
              isLoading(true);
              var furnitureData = await getUserDataFurniture("Furniture","User",personObject.id);
              Navigator.push(
                  buildContext,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>SavedFurnitureListPage(
                      title: "Saved Furniture",
                      collectionName: "Furniture",
                      dataLength: furnitureData.length,
                      Data: furnitureData,
                      parentCollection: "User",
                    )));
              isLoading(false);
          }
        ),
        TextButton.icon(
            onPressed: (){
              personObject.logOut(buildContext);
            },
            icon: const ImageIcon(
              AssetImage("assets/log_out.png"),
              color: Colors.white,
              size: 40,
            ),
            label: const Text("Log out",style: TextStyle(fontSize: 20),),
            style:TextButton.styleFrom(
              primary: Colors.white,
            )
        ),
      ],
    ),
  );
}