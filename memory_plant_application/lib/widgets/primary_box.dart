import 'package:flutter/material.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class PrimaryBox extends StatelessWidget {
  final double height; // 높이를 동적으로 설정할 수 있도록 추가
  final Duration duration; // 애니메이션 지속 시간을 설정하는 변수

  const PrimaryBox({
    super.key,
    required this.height,
    this.duration = const Duration(milliseconds: 700), // 기본값을 700ms로 설정
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut, // 애니메이션 곡선 설정
      height: height,
      decoration: BoxDecoration(
        color: AppStyles.maindeepblue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
    );
  }
}