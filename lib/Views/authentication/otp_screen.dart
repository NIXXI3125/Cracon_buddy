import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class otpScreen extends StatelessWidget {
  otpScreen({super.key});
  TextEditingController otpcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(30, 60, 87, 1),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Enter the code sent to the number',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(133, 153, 170, 1),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '+995 123 3456',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(30, 60, 87, 1),
              ),
            ),
            const SizedBox(height: 32),
            Pinput(
              length: 4,
              controller: otpcontroller,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                height: 68,
                width: 64,
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: borderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  color: errorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }
}
