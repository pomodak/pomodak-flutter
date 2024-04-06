import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/inventory_bottom_sheet.dart';

class ShowEggInventoryButton extends StatelessWidget {
  const ShowEggInventoryButton({super.key});

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const EggInventoryBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openBottomSheet(context),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(50, 48),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Image.network(CDNImages.nest, width: 48, height: 48),
    );
  }
}
