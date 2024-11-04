import 'package:flutter/material.dart';
import 'package:memory_plant_application/styles/app_styles.dart';


class BlueBox extends StatelessWidget {
  const BlueBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      )
    );
  }
}
