import 'package:corner_ar_gp/components/buttons_components.dart';
import 'package:flutter/material.dart';
import '../main_screens/edit_info/edit_person_info.dart';
import '../main_screens/list_page/SavedFurntiureListPage.dart';
import '../person/Person.dart';
import 'getdata_components.dart';


Drawer sideMenu(
{
  required bool isAdmin,
  required BuildContext buildContext,
  required Person personObject,
  required Function isLoading,
  Function? spwan
}
    ){
  return Drawer(

    backgroundColor: const Color(0xFFF87217),
    child: Container(
      margin: const EdgeInsets.only(top: 20),
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
              onPressedButton: (){
                Navigator.pop(buildContext);
                Navigator.push(
                    buildContext,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => EditPersonInformation(personObject)
                    )
                );
              }
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
          const SizedBox(height: 80,),
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
    ),
  );
}