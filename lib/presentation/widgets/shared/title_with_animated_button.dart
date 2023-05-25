import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TitleWithAnimatedButton extends StatelessWidget {
  final String title;
  final String? subtitle;
  final ValueNotifier<bool> buttonVisible;
  final ScrollController scrollController;

  const TitleWithAnimatedButton({super.key, 
    this.subtitle,
    required this.title,
    required this.buttonVisible,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // const titleStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return ValueListenableBuilder(
      valueListenable: buttonVisible,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(
                    title,
                    style: titleStyle,
                  ),
                ),
              const Spacer(),
              if (subtitle != null)
                FilledButton.tonal(
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.compact),
                  onPressed: () {},
                  child: Text(subtitle!),
                ),
              const SizedBox(width: 3),
              if (value)
                FadeIn(
                  child: FilledButton.tonal(
                    style:
                        const ButtonStyle(visualDensity: VisualDensity.compact),
                    onPressed: () {
                      scrollController.animateTo(0.0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.decelerate);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}