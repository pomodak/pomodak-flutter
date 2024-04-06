import 'package:flutter/material.dart';

class EggAddCard extends StatelessWidget {
  final VoidCallback onNavigateToShop;

  const EggAddCard({super.key, required this.onNavigateToShop});

  @override
  Widget build(BuildContext context) {
    void handleClick() {
      Navigator.of(context).pop();
      onNavigateToShop();
    }

    return Material(
      child: InkWell(
        onTap: handleClick,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.add)],
            ),
          ),
        ),
      ),
    );
  }
}
