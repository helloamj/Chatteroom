import 'package:chatteroom/pages/AnonymousSignIn.dart';
import 'package:chatteroom/pages/SignInUpPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/theme.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/network.png',
                    width: Ui.width! / 1.5,
                    height: Ui.height! / 3,
                  ),
                  Wrap(
                    children: [
                      Text(
                        'Welcome to ',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'Chatteroom!',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'The Chatteroom app is a convenient and user-friendly platform that enables users to engage in private conversations with a particular individual. It provides a seamless and secure way to connect and communicate in real-time, fostering meaningful interactions and connections. ',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const SignInUpPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Continue with Phone Number',
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     style: Theme.of(context)
                  //         .elevatedButtonTheme
                  //         .style!
                  //         .copyWith(
                  //             backgroundColor:
                  //                 MaterialStatePropertyAll(Colors.black)),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           CupertinoPageRoute(
                  //               builder: (_) => const AnonymousSignIn()));
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const Icon(Icons.visibility_off),
                  //         const SizedBox(
                  //           width: 20,
                  //         ),
                  //         Text(
                  //           'Anonymous Chat Room',
                  //           style: Theme.of(context).textTheme.displayMedium,
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
