import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/getdata_components.dart';
import '../../components/gridview_component.dart';


class SavedFurnitureListPage extends StatefulWidget {
  String title;
  String collectionName;
  var Data;
  int dataLength;
  String parentCollection;
  Function? spwan;
  SavedFurnitureListPage({required this.title,required this.collectionName,
    required this.Data,required this.dataLength,
    required this.parentCollection,this.spwan});
  @override
  _SavedFunitureListPageState createState() =>
      _SavedFunitureListPageState(this.title,this.collectionName,this.Data,this.dataLength,parentCollection);
}

class _SavedFunitureListPageState extends State<SavedFurnitureListPage> {
  String title;
  String collectionName;
  var data;
  var originalData;
  String categoryID = '';
  int dataLength;
  String parentCollection;
  bool isLoading = false;
  _SavedFunitureListPageState(this.title,this.collectionName,this.data,
      this.dataLength,this.parentCollection){
    originalData = this.data;
  }

  @override
  void initState() {
    print(dataLength);
    setState(() {});
    super.initState();
  }

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
      body: Stack(
        children: [
          Image.asset(
            'assets/backgroundTop.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          gridview_furnitureList(
              dataLength: dataLength,
              spwan: widget.spwan,
              isSpwaned: true,
              data: data,
              icon: const ImageIcon(
                AssetImage("assets/remove.png"),
                color: Colors.red,
              ),
              onPressed: (index)async{
                setIsLoading(true);
                var newData;

                await FirebaseFirestore.instance.collection(parentCollection)
                    .doc(data[index]["parentID"]).collection(collectionName).doc(data[index]['id'])
                    .delete()
                    .then((_) async {
                  newData = await getUserDataFurniture(collectionName,parentCollection,data[index]["parentID"]);
                }).catchError((error) => print('Delete failed: $error'));
                setState((){
                  data = newData;
                  dataLength = data.length;
                });
                setIsLoading(false);
              }
          ),
          if (isLoading) const Center(
            child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
          ),
        ],
      ),
    );
  }
}
