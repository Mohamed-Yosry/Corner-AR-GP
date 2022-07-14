import 'package:flutter/material.dart';
import '../main_screens/list_page/FurnitureListPage.dart';
import '../main_screens/list_page/ListPage.dart';
import 'getdata_components.dart';

////////
ElevatedButton LogAndRegisterButton(
{
  required String buttonText,
  required VoidCallback onPressedButton
}
    ){
  return ElevatedButton(
    onPressed: onPressedButton,
    child: Text(
      buttonText,
      style: TextStyle(
        fontSize: 22,
      ),
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.white,
      onPrimary: Color(0xFFF87217),
      fixedSize: const Size(200, 50),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)),
    ),
  );
}

// ElevatedButton AdminHomeScreenButton(
// {
//   required String collectionName,
//   required BuildContext context,
//   required String buttonName,
//   required String pageName,
//   required Function isLoading
// }
//     ){
//   var Data;
//   var furnitureData;
//
//   return ElevatedButton(
//       onPressed: ()async{
//         isLoading(true);
//         //Data = await getData(collectionName);
//         print(Data);
//         print("innnnnnnished");
//         if(collectionName == "Furniture"){
//           Data = await getData("Category");
//           furnitureData = await getDataFurniture(collectionName,"Category");
//           Navigator.push(
//               context,
//               MaterialPageRoute<void>(
//                 builder: (BuildContext context) =>
//                     FurnitureListPage(
//                       spawned: false,
//                       title:pageName,
//                         collectionName:collectionName,
//                         Data: furnitureData[0],
//                         dataLength: furnitureData[0].length,
//                         parentData: Data,
//                       furnitureInCategory: furnitureData[1],
//                       isViewing: false,
//                         parentCollection: "Category",
//                       parentID: "",
//                     ),
//               )
//           );
//         }else{
//           Data = await getData(collectionName);
//           Navigator.push(
//               context,
//               MaterialPageRoute<void>(
//                 builder: (BuildContext context) =>
//                     ListPage(
//                         title:pageName,
//                         collectionName:collectionName,
//                         Data: Data,
//                         dataLength: Data.length
//                     ),
//               )
//           );
//         }
//         isLoading(false);
//       },
//       child: Text(buttonName));
// }



Container listMenuButtons(
{
  required String buttonName,
  required VoidCallback onPressedButton
}
    ){
  return Container(
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
        onPressed: onPressedButton,
        child: Text(buttonName,style: TextStyle(fontSize: 20),),
        style:ElevatedButton.styleFrom(
          primary: Color(0xFFE56717),
          onPrimary: Colors.white,
        )
    ),
  );
}