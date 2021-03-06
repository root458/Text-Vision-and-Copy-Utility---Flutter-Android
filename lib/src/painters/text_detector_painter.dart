import 'dart:ui';
import 'dart:ui' as ui;

import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:vision_text/src/services/firebase_functions.dart';
import 'package:vision_text/src/services/notification_provider.dart';

import 'coordinates_translator.dart';

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.recognisedText, this.absoluteImageSize,
      this.rotation, this.notificatioProvider);

  final RecognisedText recognisedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final NotificatioProvider notificatioProvider;

  // ignore: prefer_final_fields
  List<Path> _paths = [];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    for (final textBlock in recognisedText.blocks) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));
      builder.addText(textBlock.text);
      builder.pop();

      final left =
          translateX(textBlock.rect.left, rotation, size, absoluteImageSize);
      final top =
          translateY(textBlock.rect.top, rotation, size, absoluteImageSize);
      final right =
          translateX(textBlock.rect.right, rotation, size, absoluteImageSize);
      final bottom =
          translateY(textBlock.rect.bottom, rotation, size, absoluteImageSize);

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      // Add path to list of paths
      _paths.add(Path()..addRect(Rect.fromLTRB(left, top, right, bottom)));

      canvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: right - left,
          )),
        Offset(left, top),
      );
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return oldDelegate.recognisedText != recognisedText;
  }

  @override
  bool? hitTest(Offset position) {
    // Print the words in the tapped rectangle
    for (int i = 0; i < _paths.length; i++) {
      if (_paths[i].contains(position)) {
        // Copy text, alert user
        FlutterClipboard.copy(recognisedText.blocks[i].text)
            .then((_copiedText) async {
          // Alert user
          notificatioProvider.alterVisibility();
          Future.delayed(const Duration(seconds: 2)).then((value) {
            notificatioProvider.alterVisibility();
          });
          // Send to desktop
          AuthService _authService = AuthService();
          DataBase _dataBase = DataBase();
          if (_authService.signedIn()) {
            // Go ahead to write to database
            await _dataBase.addCopiedText({
              'text': recognisedText.blocks[i].text,
              'date': DateTime.now().toString()
            });
          } else {
            User? user = await _authService.signInAnon();

            if (user != null) {
              // Write to database
              await _dataBase.addCopiedText({
              'text': recognisedText.blocks[i].text,
              'date': DateTime.now().toString()
            });
            }
          }
        });
      }
    }
    return super.hitTest(position);
  }
}
