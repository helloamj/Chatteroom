import 'package:chatteroom/firebase/SignInUp.dart';
import 'package:chatteroom/firebase_options.dart';
import 'package:chatteroom/models/UserModel.dart';
import 'package:chatteroom/pages/HomePage.dart';
// import 'package:chatteroom/pages/AnonymousSignIn.dart';
// import 'package:chatteroom/pages/JoinChatteroom.dart';
// import 'package:chatteroom/pages/OtpPage.dart';
// import 'package:chatteroom/pages/SignInUpPage.dart';
import 'package:chatteroom/pages/UserDetailSetupPage.dart';
import 'package:chatteroom/pages/WelcomePage.dart';
// import 'package:chatteroom/pages/WelcomePage.dart';
import 'package:chatteroom/provider/WelcomePageProvider.dart';
import 'package:chatteroom/ui/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  if (user != null) {
    FirebaseMethods.user=user;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.phoneNumber)
        .get();
    Map<String, dynamic> mp = snapshot.data() as Map<String, dynamic>;
    userModel = UserModel.fromMap(mp);
  }

  runApp(user == null
      ? MyApp()
      : MyHomePage(
          userModel: userModel,
        ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Ui.setwh(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WelcomePageProvider>(
          create: (context) => WelcomePageProvider(),
        ),
      ],
      child: MaterialApp(
        theme: Ui.getTheme(),
        debugShowCheckedModeBanner: false,
        home: const WelcomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  UserModel? userModel;
  MyHomePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    Ui.setwh(context);
     UserModel.mainuserModel=userModel;
    return MaterialApp(
      theme: Ui.getTheme(),
      debugShowCheckedModeBanner: false,
      home: HomePage(
        userModel: userModel,
      ),
    );
  }
}
