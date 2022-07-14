import 'dart:io';
import 'package:camera/camera.dart';
import 'package:corner_ar_gp/components/getdata_components.dart';
import 'package:corner_ar_gp/main_screens/home_screen/user_homescreen.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:async';

class Camera extends StatefulWidget {
  static const routeName = 'camera';

  List<CameraDescription> cameras;
  Camera(this.cameras);//,this.cameraController);

  @override
  _CameraState createState() => _CameraState(cameras);
}

class _CameraState extends State<Camera> {
  List<CameraDescription> cameras;
  _CameraState(this.cameras);

  bool img = false;
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;


  @override
  initState(){
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture= cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(
              child:Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Skip",style: TextStyle(fontSize: 20,color: Colors.white),),
                  Icon(Icons.navigate_next,color: Colors.white,),
                ],
              ),
            onPressed: () async{
              var categoryData = await getData("Category");
              var furnitureData = await getDataFurniture("Furniture","Category");
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => UserHomeScreen(const [],categoryData,furnitureData),
                ),
              );
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,20),
                  child: CameraPreview(cameraController),
                ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          MaterialButton(
            onPressed: () async {
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;
                // Attempt to take a picture and get the file `image` where it was saved.
                final image = await cameraController.takePicture();
                final ImageProvider imageprovide = Image.file(File(image.path)).image;
                // If the picture was taken, display it on a new screen.
                //AssetImage(image.name),
                PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
                  imageprovide,
                  size: const Size(256.0, 170.0),
                  maximumColorCount: 20,
                );

                List paletteColors = [];

                if(paletteGenerator.dominantColor!=null) {
                  paletteColors.add(paletteGenerator.dominantColor?.color);
                }
                if(paletteGenerator.lightMutedColor!=null) {
                  paletteColors.add(paletteGenerator.lightMutedColor?.color);
                }
                if(paletteGenerator.lightVibrantColor!=null) {
                  paletteColors.add(paletteGenerator.lightVibrantColor?.color);
                }
                if(paletteGenerator.darkVibrantColor!=null) {
                  paletteColors.add(paletteGenerator.darkVibrantColor?.color);
                }
                if(paletteGenerator.darkMutedColor!=null) {
                  paletteColors.add(paletteGenerator.darkMutedColor?.color);
                }
                if(paletteGenerator.vibrantColor!=null) {
                  paletteColors.add(paletteGenerator.vibrantColor?.color);
                }
                if(paletteGenerator.mutedColor!=null) {
                  paletteColors.add(paletteGenerator.mutedColor?.color);
                }

                var categoryData = await getData("Category");
                var furnitureData = await getDataFurniture("Furniture","Category");
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => UserHomeScreen(paletteColors,categoryData,furnitureData),
                  ),
                );
              } catch (e) {
                print("camera error: $e");
              }
            },
            color: Colors.black,
            padding: const EdgeInsets.all(30),
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white, width: 5)
            ),
          )
        ],
      ),
    );
  }
}


