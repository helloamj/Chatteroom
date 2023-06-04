import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../firebase/SignInUp.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_rounded),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Verify OTP',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    Text(
                      'Enter ',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 20),
                    ),
                    Text(
                      'OTP',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 20, color: Colors.deepPurple),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Pinput(
                  autofocus: true,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(30, 60, 87, 1),
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  length: 6,
                  onCompleted: (pin) {
                    showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  });
                    FirebaseMethods.verifyOTP(pin, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
