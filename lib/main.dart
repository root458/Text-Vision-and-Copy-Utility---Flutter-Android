import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_text/src/controller_service.dart';
import 'package:vision_text/src/text_detectorv2_view.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ControllerService(),
      child: MaterialApp(
        title: 'Vision Text',
        theme: ThemeData(
          fontFamily: 'Euclid',
          primarySwatch: Colors.blue,
        ),
        // home: HomePage(
        //   cameras: cameras,
        // ),
        home: const TextDetectorV2View(),
      ),
    );
  }
}
