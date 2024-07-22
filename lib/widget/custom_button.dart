import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final Color? backgroundColor;
  final Widget child;

  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: WidgetStatePropertyAll(0),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10).r)),
            backgroundColor:
                WidgetStatePropertyAll(backgroundColor ?? AppColor.green)),
        onPressed: onPressed,
        child: child);
  }
}
