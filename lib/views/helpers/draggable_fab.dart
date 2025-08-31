import 'package:flutter/material.dart';

class DraggableFab extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const DraggableFab({super.key, required this.child, required this.onPressed});

  @override
  _DraggableFabState createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> {
  Offset offset = const Offset(20, 500); // default position

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset = Offset(
              offset.dx + details.delta.dx,
              offset.dy + details.delta.dy,
            );
          });
        },
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
