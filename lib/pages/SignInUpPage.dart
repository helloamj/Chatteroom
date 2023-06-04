import 'package:chatteroom/firebase/SignInUp.dart';
import 'package:flutter/material.dart';

class SignInUpPage extends StatefulWidget {
  const SignInUpPage({super.key});

  @override
  State<SignInUpPage> createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    countryCode.text = '+91';
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
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
              print("${countryCode.text}${phoneNumber.text}".trim());
              FirebaseMethods.sendOTP(
                  "${countryCode.text}${phoneNumber.text}".trim(), context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Send OTP',
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
                      'Phone Number',
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                          controller: countryCode,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 18),
                          keyboardType: TextInputType.phone),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: phoneNumber,
                        decoration: InputDecoration(
                            hintText: 'Ex: 9057508437',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 18,
                                    color: Color.fromARGB(172, 119, 119, 119))),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 18),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
