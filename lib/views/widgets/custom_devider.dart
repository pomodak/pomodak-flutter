import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final Color? color;
  final double? height;
  final TextStyle? textStyle;

  const CustomDivider({
    super.key,
    this.text = "또는",
    this.color,
    this.height = 16.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: Divider(
              color: color ?? Colors.black12,
              height: height,
            ),
          ),
        ),
        Text(
          text,
          style: textStyle ?? TextStyle(color: color ?? Colors.black87),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Divider(
              color: color ?? Colors.black12,
              height: height,
            ),
          ),
        ),
      ],
    );
  }
}
