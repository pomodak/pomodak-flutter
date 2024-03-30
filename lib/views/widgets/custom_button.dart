import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool disabled;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final dynamic icon; // Icon or SvgPicture
  final Color borderColor;
  final double borderWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.disabled = false,
    required this.onTap,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderColor = Colors.black12,
    this.borderWidth = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [
      if (icon != null) ...[
        icon,
        const SizedBox(width: 12),
      ],
      Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];

    return GestureDetector(
      onTap: isLoading || disabled ? null : onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isLoading
                ? Colors.grey
                : (disabled
                    ? Colors.grey.shade400
                    : backgroundColor), // 로딩 중이거나 비활성화 상태면 회색 배경
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: borderColor, width: borderWidth)),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor,
                  ),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowChildren,
              ),
      ),
    );
  }
}
