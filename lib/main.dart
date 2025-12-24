import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmai_pro/src/application.dart';

void main() {
  runApp(ProviderScope(child: const Application()));
}
