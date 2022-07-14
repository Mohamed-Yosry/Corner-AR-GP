import 'package:camera/camera.dart';
import 'package:corner_ar_gp/ColorDetection/Camera/camera.dart';
import 'package:corner_ar_gp/main_screens/home_screen/admin_homescreen.dart';
import 'package:corner_ar_gp/provider_manager/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/Data.dart';

import '../../components/getdata_components.dart';

class LoadingScreen extends StatelessWidget {
  static const routeName = 'loadingScreen';

  @override
  Widget build(BuildContext context) {
    late final _myAppProvider =  Provider.of<AppProvider>(context);

    _myAppProvider.isLoggedUserAdmin().then((value)async{
      WidgetsFlutterBinding.ensureInitialized();
      List<CameraDescription> cameras = await availableCameras();
      var adminData = await getData("Admin");
      var categoryData = await getData("Category");
      var furnitureData = await getDataFurniture("Furniture","Category");
      Data dataObject = Data(adminData, categoryData, furnitureData);
      Navigator.pushReplacement<void, void>(
        context,
        value?MaterialPageRoute<void>(
          builder: (BuildContext context) => AdminHomeScreen(0,"Admin List",dataObject)
        ):MaterialPageRoute<void>(
          builder: (BuildContext context) => Camera(cameras),
        ),
      );
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF87217)
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/backgroundTop.png',
              fit: BoxFit.fill,
              //height: double.infinity,
              width: double.infinity,
            ),
            const Center(
              child: CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.orange,),
            )
          ],
        )
    );
  }
}
