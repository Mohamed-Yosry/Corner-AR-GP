import 'package:corner_ar_gp/components/drawer_component.dart';
import 'package:corner_ar_gp/main_screens/edit_info/edit_person_info.dart';
import 'package:corner_ar_gp/my_color_picker/myColorPicker.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../components/getdata_components.dart';
import '../list_page/FurnitureListPage.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';


class UserHomeScreen extends StatefulWidget {
  static const routeName = 'userHomeScreen';
  late var paletteGenerator;
  UserHomeScreen(this.paletteGenerator);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState(this.paletteGenerator);
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late var paletteGenerator;
  _UserHomeScreenState(this.paletteGenerator);
  late Person loggedUser;
  late String sideMenuContent;
  bool isLoading = false;
  Color currentColor = Colors.amber;
  bool isSelected=false;

   late UnityWidgetController _unityWidgetController;
  void changeColor(Color color)  => ChangeColors(colorToHex(color).toString());



  void setIsLoading(value){
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    final _myAppProvider =  Provider.of<AppProvider>(context);
    loggedUser = _myAppProvider.getLoggedUser();
    sideMenuContent = loggedUser.name;

    print(paletteGenerator);


    return Scaffold(
      drawer: sideMenu(
          isAdmin: false,
          buildContext:context,
          personObject:loggedUser,
          isLoading: (value)=>setIsLoading(value),
        spwan: (value) =>spwan(value)
      ),
      appBar: AppBar(
        title: Text("User"),
        backgroundColor: Color(0xFFF87217),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMessage,
              fullscreen: false,
            ),
          ),
          if (isLoading) const Center(
            child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
          ),
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         isSelected? MyColorPicker(
              pickerColor: currentColor,
              onColorChanged: changeColor,
              paletteColors: paletteGenerator
          ):Container(),
          SizedBox(height: 10,),
        isSelected? FloatingActionButton(
            onPressed: () {
              Delete();
            }
            ,child: Icon(Icons.delete),
            backgroundColor: Color(0xFFF87217),
          ):Container(),

          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () async{
              setIsLoading(true);
              var Data = await getData("Category");
              var furnitureData = await getDataFurniture("Furniture","Category");
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Center(
                      child: FurnitureListPage(
                        context: context,
                        spwan: (value) =>spwan(value),
                        title: "Spawn Furniture",
                        collectionName: "Furniture",
                        furnitureInCategory: furnitureData[1],
                        parentData: Data,
                        dataLength: furnitureData[0].length,
                        Data: furnitureData[0],
                        isViewing: true,
                        parentCollection: "User",
                        parentID: loggedUser.id,
                        spawned: true,

                      ),
                    ),
                  );
                },
              );
              setIsLoading(false);
            }
            ,child: Icon(Icons.add),
            backgroundColor: Color(0xFFF87217),
          ),
        ],
      ),
    );
  }

  //Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  void onUnityMessage(message) {
      print(message.toString());

    if (message.toString() == "selected") {

      isSelected=true;
  }

    if (message.toString() == "deselected") {

      isSelected=false;
    }

    setState(() {

    });
  }

   spwan(String url){

    _unityWidgetController.postMessage(
      'ContentParent',
      'LoadContent',
       url,
    );
    Navigator.pop(context);
    print("insid spwan ");

  }


  Delete(){

    _unityWidgetController.postMessage(
      'ContentParent',
      'DeleteItem',
      ""
    );

  }


  ChangeColors(String color){
    print(color);

    color=color.substring(2,color.length);
    color="#"+color;

    print(color);

    _unityWidgetController.postMessage(
        'ContentParent',
        'ChangeColor',
         color
    );



  }


}


