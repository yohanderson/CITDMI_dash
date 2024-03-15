import 'package:flutter/material.dart';

class SnackBarMessaging {

  void showOverlay(BuildContext context, String error, Color color) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        child: Material(
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: color,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(error,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black
                  ),),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}