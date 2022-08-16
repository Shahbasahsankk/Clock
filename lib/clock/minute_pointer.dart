import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinutePointer extends StatelessWidget {
  const MinutePointer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.11.h;
    final minute = DateTime.now().minute.toDouble();
    final angle = (-pi * (minute / -60)) * 2;
    return RotatedBox(
      quarterTurns: 2,
      child: Transform.rotate(
        angle: angle,
        child: Transform.translate(
          offset: const Offset(0, 30),
          child: Center(
            child: Container(
              height: height,
              width: 4.w,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(32.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}