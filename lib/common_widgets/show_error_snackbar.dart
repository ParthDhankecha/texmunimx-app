import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String title, {String? desc}) {
  log('Showing error snackbar: $title, desc: $desc');
  final overlay = Overlay.of(Get.overlayContext!);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return _AnimatedTopSnackbar(
        title: title,
        desc: desc,
        onDismissed: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}

class _AnimatedTopSnackbar extends StatefulWidget {
  final String title;
  final String? desc;
  final VoidCallback onDismissed;

  const _AnimatedTopSnackbar({
    required this.title,
    this.desc,
    required this.onDismissed,
  });

  @override
  State<_AnimatedTopSnackbar> createState() => _AnimatedTopSnackbarState();
}

class _AnimatedTopSnackbarState extends State<_AnimatedTopSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _offsetAnimation =
        Tween<Offset>(
          begin: const Offset(0, -2),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      //if already dismissed, do nothing
      if (!mounted) return;
      await _controller.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: GestureDetector(
          onVerticalDragUpdate: (details) => {
            if (details.delta.dy < 0)
              {_controller.reverse().then((value) => widget.onDismissed())},
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.desc != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.desc!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
