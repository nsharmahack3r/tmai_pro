import 'dart:io';

import 'package:flutter/services.dart';

class NativeSplash {
  static const _channel = MethodChannel('app/splash');

  static Future<void> close() async {
    if (Platform.isMacOS) {
      await _channel.invokeMethod('closeSplash');
    }
  }
}
