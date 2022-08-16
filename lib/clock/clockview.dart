// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stopwatch/clock/analogic.dart';
import 'package:stopwatch/clock/hour_pointer.dart';
import 'package:stopwatch/clock/minute_pointer.dart';
import 'package:stopwatch/clock/second_pointer.dart';

class ClockView extends StatelessWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        const Duration(seconds: 1),
      ),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const AnalogicCircle(),
                  HourPointer(),
                  MinutePointer(),
                  SecondPointer(),
                  Container(
                    height: 16.h,
                    width: 16.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
               SizedBox(
                height: 20.h,
              ),
              Text(
                DateFormat('h:mm a').format(DateTime.now()),
                style:  TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
