import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class RecognizeTextService {
  static Future<RecognisedText> recognizeTextFromImage(XFile imageFile) async {
    final inputImage = InputImage.fromFile(File(imageFile.path));
    final RecognisedText _recognizedText =
        await GoogleMlKit.vision.textDetectorV2().processImage(inputImage);
    return _recognizedText;
  }
}
