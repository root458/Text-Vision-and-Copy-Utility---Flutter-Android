import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: SpinKitDoubleBounce(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.flash_on),
          onPressed: () => controller.setFlashMode(FlashMode.torch),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('Vision Text'),
      ),
      body: Column(
        children: [
          Flexible(flex: 8, child: CameraPreview(controller)),
          Flexible(
              child: Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: const Text(
                'Analyze text',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.06)),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
            ),
          ))
        ],
      ),
    );
  }
}
