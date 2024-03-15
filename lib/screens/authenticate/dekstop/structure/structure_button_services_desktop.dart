import 'package:flutter/material.dart';

class StructureButtonServicesDesktop extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final String content;
  const StructureButtonServicesDesktop({super.key, required this.onTap, required this.icon, required this.text, required this.content});

  @override
  State<StructureButtonServicesDesktop> createState() => _StructureButtonServicesDesktopState();
}

class _StructureButtonServicesDesktopState extends State<StructureButtonServicesDesktop> {

  bool hoverButton = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          hoverButton = true;
        });
      },
      onExit: (event) {
        setState(() {
          hoverButton = false;
        });
      },
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: widget.onTap,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 235,
              decoration: BoxDecoration(
                boxShadow: hoverButton ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 12,
                  ),
                ] : [],
                color: Colors.white,
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Theme.of(context).primaryColor,
                              Theme.of(context).hintColor,
                            ],
                          ).createShader(bounds);
                        },child: Icon(widget.icon, size: 100, weight: 900,)),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            widget.content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
