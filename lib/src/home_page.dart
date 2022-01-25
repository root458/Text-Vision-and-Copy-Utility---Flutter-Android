import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vision_text/src/controller_service.dart';

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
    // Get Controller Provider
    final _controllerService = Provider.of<ControllerService>(context);

    if (!controller.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            child: const FittedBox(
              child: SpinKitDoubleBounce(
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: _controllerService.flashMode == 0
              ? const Icon(Icons.flash_on)
              : const Icon(Icons.flash_off),
          onPressed: () {
            // Set flash mode off/on
            if (_controllerService.flashMode == 0) {
              controller.setFlashMode(FlashMode.torch);
            } else {
              controller.setFlashMode(FlashMode.off);
            }
            // Update flash mode status
            _controllerService.changeFlashMode();
          },
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
              onPressed: () async {
                // Take picture
                // XFile _imageFile = await controller.takePicture();
                // Pause
                controller.pausePreview();
                // Perform Detection
                // RecognisedText recognizedText =
                //     await RecognizeTextService.recognizeTextFromImage(
                //         _imageFile);

                // print(recognizedText);
              },
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

  // Future<void> processImage(InputImage inputImage) async {
  //   if (isBusy) return;
  //   isBusy = true;
  //   final recognisedText = await textDetector.processImage(inputImage,
  //       script: TextRecognitionOptions.DEVANAGIRI);
  //   print('Found ${recognisedText.blocks.length} textBlocks');
  //   if (inputImage.inputImageData?.size != null &&
  //       inputImage.inputImageData?.imageRotation != null) {
  //     final painter = TextDetectorPainter(
  //         recognisedText,
  //         inputImage.inputImageData!.size,
  //         inputImage.inputImageData!.imageRotation);
  //     customPaint = CustomPaint(painter: painter);
  //   } else {
  //     customPaint = null;
  //   }
  //   isBusy = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }
}
