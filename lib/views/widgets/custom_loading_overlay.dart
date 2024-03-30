import 'dart:async';
import 'package:flutter/material.dart';

void showCustomLoadingOverlay(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 200),
    barrierColor: Colors.black12.withOpacity(0.3),
    pageBuilder: (ctx, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim1, anim2, child) {
      return const PopScope(
        canPop: false,
        child: Center(
          child: BouncingLoadingIcon(),
        ),
      );
    },
  );
}

void hideCustomLoadingOverlay(BuildContext context) {
  Navigator.of(context).pop();
}

class BouncingLoadingIcon extends StatefulWidget {
  const BouncingLoadingIcon({super.key});

  @override
  State<BouncingLoadingIcon> createState() => _BouncingLoadingIconState();
}

class _BouncingLoadingIconState extends State<BouncingLoadingIcon> {
  double _bounceHeight = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _bounceHeight = _bounceHeight == 0.0 ? 20.0 : 0.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, _bounceHeight, 0),
      child: Image.asset(
        'assets/icons/mascot-100x100.png',
        width: 50,
        height: 50,
      ),
    );
  }
}
