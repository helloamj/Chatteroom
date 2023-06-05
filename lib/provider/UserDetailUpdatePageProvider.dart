
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class UserDetailUpdateProvider with ChangeNotifier{

 File? imageFile;

 void setimageFile(File? newImage)
{
  imageFile = newImage;
  notifyListeners();
}

}