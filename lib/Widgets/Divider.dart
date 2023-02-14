import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final Color? customColor;
  DividerWidget({Key? key, required this.customColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.0,
      color: customColor,
      thickness: 1.0,
    );
  }
}
