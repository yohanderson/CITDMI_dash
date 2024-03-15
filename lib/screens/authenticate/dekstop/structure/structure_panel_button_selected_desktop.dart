import 'package:flutter/material.dart';
class StructurePanelButtonSelectedDesktop extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;

  const StructurePanelButtonSelectedDesktop({super.key, required this.onTap, required this.icon, required this.text});

  @override
  State<StructurePanelButtonSelectedDesktop> createState() => _StructurePanelButtonSelectedDesktopState();
}

class _StructurePanelButtonSelectedDesktopState extends State<StructurePanelButtonSelectedDesktop> {

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
              height: 180,
              width: 200,
              decoration: BoxDecoration(
                boxShadow: hoverButton ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 12,
                  ),
                ] : [],
                gradient:  LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.onPrimary,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned(
                        top: 91,
                        left: 95,
                        child: ShaderMask(
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
                            },child: Icon(widget.icon, size: 120, weight: 900,))),
                    Center(
                      child: Text( widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hoverButton == true) ...[
              Container(
                width: 200,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Theme.of(context).colorScheme.onPrimary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 10,
                        child: ShaderMask(
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
                            },child: Icon(widget.icon, size: 60, weight: 900,))),
                    Center(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
