import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tmai_pro/src/resource/assets.gen.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.message,
    required this.anActionTap,
    required this.actionText,
  });

  final String message;
  final VoidCallback anActionTap;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(Assets.animations.empty),
        Text(message),
        MaterialButton(onPressed: anActionTap, child: Text(actionText)),
      ],
    );
  }
}
