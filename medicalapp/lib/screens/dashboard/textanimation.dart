import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollingText extends StatefulWidget {
  final String text;

  const AutoScrollingText({super.key, required this.text});

  @override
  _AutoScrollingTextState createState() => _AutoScrollingTextState();
}

class _AutoScrollingTextState extends State<AutoScrollingText>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      _controller!.forward();
    });
    return Container(
      child: FractionalTranslation(
        translation: _offsetAnimation!.value,
        child: Text(widget.text),
      ),
    );
  }
}
