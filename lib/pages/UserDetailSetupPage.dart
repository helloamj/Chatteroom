import 'dart:io';

import 'package:chatteroom/firebase/SignInUp.dart';
import 'package:chatteroom/models/UserModel.dart';
import 'package:chatteroom/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../ui/theme.dart';

class UserDetailSetupPage extends StatefulWidget {
  const UserDetailSetupPage({super.key});

  @override
  State<UserDetailSetupPage> createState() => _UserDetailSetupPageState();
}

class _UserDetailSetupPageState extends State<UserDetailSetupPage> {
  File? imageFile;

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile pickedFile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Upload Profile Picture',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: Text(
                    'Select From Gallery',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w200),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    'Take a Photo',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          );
        });
  }

  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  void uploadDetails() async {
    UploadTask uploadImage = FirebaseStorage.instance
        .ref('profilepictures')
        .child(FirebaseMethods.uphoneNumber!)
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadImage;
    String imageURL = await snapshot.ref.getDownloadURL();
    String fullname = name.text.trim();
    String ubio = bio.text.trim();
    UserModel userModel = UserModel(
      phonenumber: FirebaseMethods.uphoneNumber.toString(),
      fullname: fullname,
      bio: ubio,
      profilepic: imageURL,
    );
    Map<String, dynamic> mp = userModel.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseMethods.uphoneNumber.toString())
        .set(mp)
        .then((value) {
      print(mp);
      
          Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => HomePage(userModel: userModel,)),
                                (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (name.text.trim() == '' ||
                  bio.text.trim() == '' ||
                  imageFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Fill all Details'),
                  ),
                );
              } else {
                uploadDetails();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Start Chatting',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        'Your Details',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 20, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      showPhotoOptions();
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          (imageFile != null) ? FileImage(imageFile!) : null,
                      backgroundColor:
                          Theme.of(context).primaryColor.withAlpha(200),
                      radius: Ui.width! / 3.5,
                      child: Center(
                        child: (imageFile == null)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: Ui.width! / 4,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Upload Picture',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                        hintText: 'Full Name',
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
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: bio,
                    decoration: InputDecoration(
                        hintText: 'Bio...',
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
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
