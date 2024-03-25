import 'package:flutter/material.dart';

class ShowEggInventoryButton extends StatelessWidget {
  const ShowEggInventoryButton({super.key});

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        // 전체 너비를 계산합니다.
        return Container(
          height: 300,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            print('Card ${index + 1} tapped');
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.egg),
                              Text('Egg ${index + 1}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
        minimumSize: const Size(50, 60),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: const Icon(
        Icons.egg_outlined,
      ),
    );
  }
}
