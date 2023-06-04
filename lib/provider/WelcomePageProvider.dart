
import 'dart:async';

import 'package:flutter/material.dart';

class WelcomePageProvider with ChangeNotifier{

   int _number = 0;
  Timer? _timer;
   WelcomePageProvider()
   {
    getnum ();
   } 
   int get number=>_number;
   void getnum ()  {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (_number < 1000) {
        _number++;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
   }

}