import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({Key? key}) : super(key: key);

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;
  bool isPaused = false;
  double progress = 1.0;
  bool stopNotify = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void notify() {
    if (countText == '0:00:00') {
      isPlaying = false;
      stopNotify = true;
      FlutterRingtonePlayer.play(
        volume: 1,
        looping: true,
        asAlarm: true,
        fromAsset: "lib/assets/iphone_timer_sound.mp3",
        ios: IosSounds.glass,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          isPlaying == true
              ? Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 200.h,
                        width: 200.w,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.shade300,
                          value: progress,
                          strokeWidth: 6.w,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) => Text(
                          countText,
                          style:  TextStyle(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 300.h,
                        child: CupertinoTimerPicker(
                          initialTimerDuration: controller.duration!,
                          onTimerDurationChanged: (time) {
                            setState(() {
                              controller.duration = time;
                            });
                          },
                        ),
                      ),
                    ),
                     SizedBox(
                      height: 40.h,
                    ),
                    Visibility(
                      visible: stopNotify,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            stopNotify=false;
                          });
                          FlutterRingtonePlayer.stop();
                        },
                        child: const Text(
                          'STOP',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
          const Spacer(),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 20.h,
            ),
            child: !isPlaying
                ? Center(
                    child: SizedBox(
                      width: 210.w,
                      child: RawMaterialButton(
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                          controller.reverse(
                              from: controller.value == 0
                                  ? 1.0
                                  : controller.value);
                          setState(() {
                            isPlaying = true;
                            isPaused = false;
                          });
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
                          fillColor: const Color.fromARGB(255, 220, 163, 163),
                          onPressed: () {
                            FlutterRingtonePlayer.stop();
                            controller.reset();
                            setState(() {
                              isPlaying = false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                       SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            if (controller.isAnimating) {
                              controller.stop();
                              setState(() {
                                isPaused = true;
                              });
                            } else {
                              controller.reverse(
                                  from: controller.value == 0
                                      ? 1.0
                                      : controller.value);
                              setState(() {
                                isPlaying = true;
                                isPaused = false;
                              });
                            }
                          },
                          fillColor: const Color.fromARGB(255, 242, 17, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Text(
                            isPaused == false ? 'Pause' : 'Resume',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
