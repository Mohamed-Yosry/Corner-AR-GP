import 'package:corner_ar_gp/components/drawer_component.dart';
import 'package:corner_ar_gp/person/Person.dart';
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/Data.dart';
import '../../person/Admin.dart';
import '../list_page/FurnitureListPage.dart';
import '../list_page/ListPage.dart';

class AdminHomeScreen extends StatefulWidget {
  static const routeName = 'adminHomeScreen';
  Data dataObject;
  int _selectedIndex;
  String title;
  AdminHomeScreen(this._selectedIndex,this.title,this.dataObject);
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState(_selectedIndex,title,dataObject);
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Data dataObject;
  String title;
  int _selectedIndex = 0;
  _AdminHomeScreenState(this._selectedIndex,this.title,this.dataObject);
  late Person loggedUser;
  late String sideMenuContent;
  bool isLoading = false;
  late Widget temp = ListPage(
    dataObject: dataObject,
    collectionName:Admin.CollectionName,
    data: dataObject.adminData,
    dataLength: dataObject.adminData.length,
  );

  @override
  void initState() {
    _onItemTapped(_selectedIndex);
    super.initState();
  }


  void setIsLoading(value) {
    setState(() {
      isLoading = value;
    });
  }

  void _onItemTapped(int index){
    setIsLoading(true);
    if(index == 0){
      title = "Admins List";
      temp = ListPage(
        dataObject: dataObject,
        collectionName:Admin.CollectionName,
        data: dataObject.adminData,
        dataLength: dataObject.adminData.length,
      );
    }else if(index == 1){
      title = "Categories List";
      temp = Container(
            child: ListPage(
              dataObject: dataObject,
                collectionName:"Category",
                data: dataObject.categoryData,
                dataLength: dataObject.categoryData.length,
            ),
          );
    }else if(index == 2){
      title = "Furniture List";
      temp = FurnitureListPage(
            spawned: false,
            dataObject: dataObject,
            collectionName:"Furniture",
            data: dataObject.furnitureData[0],
            dataLength: dataObject.furnitureData[0].length,
            parentData: dataObject.categoryData,
            furnitureInCategory: dataObject.furnitureData[1],
            isViewing: false,
            parentCollection: "Category",
            parentID: "",
          );
    }
    _selectedIndex = index;
    setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    late final _myAppProvider = Provider.of<AppProvider>(context);
    loggedUser = _myAppProvider.getLoggedUser();
    sideMenuContent = loggedUser.name;

    return Scaffold(
      drawer: sideMenu(
          isAdmin: true,
          buildContext: context,
          personObject: loggedUser,
          isLoading: () {}),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color(0xFFF87217),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/backgroundTop.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            child: temp//_widgetOptions.elementAt(_selectedIndex),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_delete),
            label: 'Furniture',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFF87217),
        selectedIconTheme: const IconThemeData(opacity: 0.0, size: 0),
        unselectedIconTheme: const IconThemeData(opacity: 0.0, size: 0),
        onTap: _onItemTapped,
      ),
    );
  }
}
