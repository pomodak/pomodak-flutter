import 'package:flutter/material.dart';

class ShopListItem extends StatelessWidget {
  final String imageUrl, name;
  final num price;
  final num? requiredTime;

  const ShopListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.requiredTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$price원",
                  ),
                  if (requiredTime != null)
                    Text("⌛️ ${(requiredTime! / 60).floor()}분")
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
