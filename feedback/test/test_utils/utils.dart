import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// use a portrait format for golden images
Future<void> setGoldenImageSurfaceSize(WidgetTester tester) async {
  // iPhone 11 Pro Max, portrait
  const double width = 414;
  const double height = 896;
  const double pixelRation = 3;

  tester.view.devicePixelRatio = pixelRation;
  await tester.binding.setSurfaceSize(const Size(width, height));
}
