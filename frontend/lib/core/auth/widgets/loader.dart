import 'package:flutter/material.dart';

class LoaderHUD extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator = Container(
    width: 200,
    height: 100,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Colors.black,
    ),
    child: const Center(child: CircularProgressIndicator()),
  );
  final bool dismissible;
  final Widget child;

  LoaderHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    return Stack(
      children: [
        child,
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: dismissible, color: color),
        ),
        Center(child: progressIndicator),
      ],
    );
  }
}
