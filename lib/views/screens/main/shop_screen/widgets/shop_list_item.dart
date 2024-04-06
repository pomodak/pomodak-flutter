import 'package:flutter/material.dart';
import 'package:pomodak/utils/message_util.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () {
          MessageUtil.showSuccessToast("아이템 구매");
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Image.network(
                imageUrl,
                width: 70,
                height: 70,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$price원",
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    if (requiredTime != null)
                      Text(
                        "⌛️ ${(requiredTime! / 60).floor()}분",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right,
              )
            ],
          ),
        ),
      ),
    );
  }
}
