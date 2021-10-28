import 'package:flutter/material.dart';

class DescriptionOverlay extends StatelessWidget {
  final String description;

  DescriptionOverlay(this.description);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromRGBO(0, 0, 0, 0.7),
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OverlayText('Description'),
              const Divider(
                color: Colors.white,
                thickness: 2.0,
              ),
              OverlayText(description),
            ],
          )),
    );
  }
}

class OverlayText extends StatelessWidget {
  final String text;

  OverlayText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        height: 1.5,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
