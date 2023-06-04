import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';


class JoinChatteroom extends StatefulWidget {
  const JoinChatteroom({super.key});

  @override
  State<JoinChatteroom> createState() => _JoinChatteroomState();
}

class _JoinChatteroomState extends State<JoinChatteroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                backgroundColor: const MaterialStatePropertyAll(Colors.black)),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.login),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Enter Chatteroom',
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
                      'Code',
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
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(30, 60, 87, 1),
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  length: 6,
                  onCompleted: (pin) => print(pin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
