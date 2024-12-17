import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.primary = false,
    super.key,
    required this.onPressed,
    // required this.label,
    required this.child,
    // this.labelColor,
  });

  final bool primary;
  final Function()? onPressed;
  // final String label;
  final Widget child;
  // final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onPressed != null) {
          onPressed!();
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: primary ? Colors.black : Colors.white,
        foregroundColor: primary ? Colors.white : Colors.black,
        disabledForegroundColor: primary ? Colors.white : Colors.black,
        disabledBackgroundColor: primary ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
      child: child,
    );
  }
}
