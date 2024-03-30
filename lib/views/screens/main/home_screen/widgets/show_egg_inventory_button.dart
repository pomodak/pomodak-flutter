import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';

class ShowEggInventoryButton extends StatelessWidget {
  const ShowEggInventoryButton({super.key});

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
            child: Column(
              children: [
                const Text("보유중인 알",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("최대 4개까지 보관할 수 있습니다."),
                const Text("(버릴 수 없어요. 끝까지 책임져주세요!)"),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: EggCard(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
          surfaceTintColor: Theme.of(context).colorScheme.background),
      child: Image.network(
        CDNImages.nest,
        width: 48,
        height: 48,
      ),
    );
  }
}

class EggCard extends StatelessWidget {
  const EggCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(
                CDNImages.egg,
              ),
              const Text("00:44:12")
            ],
          ),
        ),
      ),
    );
  }
}
