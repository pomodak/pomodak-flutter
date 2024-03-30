import 'dart:async';

import 'package:flutter/material.dart';

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
      if (mounted) {
        setState(() {
          _bounceHeight = _bounceHeight == 0.0 ? 20.0 : 0.0;
        });
      }
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
