import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corner_ar_gp/authentication/registration/registration_screen.dart';
import 'package:corner_ar_gp/main_screens/add_category/AddCategoryPage.dart';
import 'package:corner_ar_gp/person/Admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Data/Data.dart';
import '../../components/getdata_components.dart';
import '../../database/DatabaseHelper.dart';
import '../../person/Person.dart';
import '../../provider_manager/AppProvider.dart';


class ListPage extends StatefulWidget {
  static const routeName = 'listpage';
  Data dataObject;
  String collectionName;
  var data;
  int dataLength;
  ListPage({required this.dataObject,required this.collectionName,required this.data,required this.dataLength});
  @override
  _ListPageState createState() => _ListPageState(this.dataObject,this.collectionName,this.data,this.dataLength);
}

class _ListPageState extends State<ListPage> {
  Data dataObject;
  String collectionName;
  var data;
  int dataLength;
  _ListPageState(this.dataObject,this.collectionName,this.data,this.dataLength);
  bool isLoading = false;
  late Person loggedUser;

  late QuerySnapshot querySnapshot;

  void setIsLoading(value){
    setState(() {
      isLoading = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    late final _myAppProvider = Provider.of<AppProvider>(context);
    loggedUser = _myAppProvider.getLoggedUser();

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/backgroundTop.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          ListView.builder(
            itemCount: dataLength,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            child: Text(data[index]['name'],style: const TextStyle(fontSize: 20),),
                          padding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                      Align(
                        child: IconButton(
                          onPressed: ()async{
                            setIsLoading(true);

                            if(collectionName == "Category"){
                              deleteAllCategroyFurniture(data[index]['id']);
                            }
                            var prevID = data[index]['id'];
                            await FirebaseFirestore.instance.collection(collectionName)
                                .doc(data[index]['id'])
                                .delete()
                                .then((_) async {
                                  data = await getData(collectionName);
                                  if(collectionName == "Admin"){
                                    dataObject.adminData = data;
                                  }else if(collectionName == "Category"){
                                    dataObject.categoryData = data;
                                  }
                                }).catchError((error) => print('Delete failed: $error'));

                            setState((){
                              dataLength = data.length;
                            });
                            if(collectionName == "Admin"){
                              if(loggedUser.id == prevID) {
                                loggedUser.logOut(context);
                              }
                            }
                            setIsLoading(false);
                          },
                          icon: const ImageIcon(
                            AssetImage("assets/remove.png"),
                            color: Colors.red,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      )
                    ],
                  ),
                )
              );
            },
          ),
          if (isLoading) const Center(
            child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(collectionName == Admin.CollectionName){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>RegistrationScreen(isAdmin: true),));
          }else{
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>AddCategoryPage("Add Category",dataObject),));
          }
        }
        ,child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFF87217),
      ),
    );
  }
}