import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalogicCircle extends StatelessWidget {
  const AnalogicCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5.h,
      width: MediaQuery.of(context).size.width * 0.7.w,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow:  [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(0, 5),
              blurRadius: 15.r,
            )
          ]),
      child: Padding(
        padding:  EdgeInsets.only(left:6.w ,right:6.w ,top:6.h ,bottom: 6.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding:  EdgeInsets.only(left:20.w,right: 20.w,bottom: 20.h,top: 20.h),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
