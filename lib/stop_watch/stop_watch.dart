import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({
    Key? key,
  }) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int seconds = 0, minutes = 0, milliSeconds = 0;

  String digitSeconds = "00", digitMinutes = "00", digitMilliSeconds = "00";

  Timer? timer;

  bool started = false;
  bool paused = false;

  List laps = [];

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left:16.w,right: 16.w,top: 16.h,bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         SizedBox(
            height: 20.h,
          ),
          Container(
            height: 200.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueGrey,
                width: 3.w,
              ),
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: "$digitMinutes:$digitSeconds",
                  style:  TextStyle(
                    fontSize: 40.sp,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: ".$digitMilliSeconds",
                      style:  TextStyle(
                        fontSize: 40.sp,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
           SizedBox(
            height: 40.h,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.only(left:16.w,right: 16.w,top: 16.h,bottom: 16.h),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}",
                        style:  TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${laps[index]}",
                        style:  TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                       SizedBox(
                        width: 150.w,
                      ),
                    ],
                  ),
                );
              },
            ),
          ), 
          !started
              ? Center(
                  child: SizedBox(
                    width: 210.w,
                    child: RawMaterialButton(
                      onPressed: () {
                        start();
                      },
                      fillColor: const Color.fromARGB(255, 241, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          !paused ? reset() : addLaps();
                        },
                        fillColor: const Color.fromARGB(255, 220, 163, 163),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text(
                          !paused ? 'Reset' : 'Lap',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 237, 18, 2),
                              fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                     SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        fillColor: const Color.fromARGB(255, 242, 17, 1),
                        onPressed: () {
                          (!paused) ? start() : pause();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          (!paused) ? 'Resume' : 'Pause',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold,),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  void stop() {
    timer!.cancel();
    setState(
      () {
        started = false;
      },
    );
  }

  void clear() {
    setState(() {
      laps.clear();
    });
  }

  void pause() {
    timer!.cancel();
    setState(() {
      paused = false;
    });
  }

  void reset() {
    timer!.cancel();
    clear();
    setState(() {
      milliSeconds = 0;
      seconds = 0;
      minutes = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitMilliSeconds = "00";

      started = false;
    });
  }

  void addLaps() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    String lap = "$digitMinutes:$digitSeconds:$digitMilliSeconds";
    setState(
      () {
        laps.add(lap);
      },
    );
  }

  void start() {
    started = true;
    paused = true;
    timer = Timer.periodic(
      const Duration(milliseconds: 004),
      (timer) {
        int localMilliSeconds = milliSeconds + 1;
        int localSeconds = seconds;
        int localMinutes = minutes;
        if (localMilliSeconds > 99) {
          if (localSeconds > 59) {
            localMinutes++;
            localSeconds = 0;
          } else {
            localSeconds++;
            localMilliSeconds = 0;
          }
        }
        setState(() {
          seconds = localSeconds;
          minutes = localMinutes;
          milliSeconds = localMilliSeconds;
          digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
          digitMilliSeconds =
              (milliSeconds >= 10) ? "$milliSeconds" : "0$milliSeconds";
          digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        });
      },
    );
  }
}
