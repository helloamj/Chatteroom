import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../ui/theme.dart';

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({
    Key? key,
    required this.callID,
    required this.user_id,
    required this.user_name,
  }) : super(key: key);

  final String callID;
  final String user_id;
  final String user_name;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1301213038,
      appSign:
          "827c61f1eb95ded9705847d8d75ea7ba3e8d29f77821ee7a134192eca3134241",
      userID: user_id,
      userName: user_name,
      callID: callID,
      onDispose: () {
        FirebaseFirestore.instance
            .collection('vc')
            .doc(callID)
            .set({'VideoCall': false}).then((value) => Navigator.pop(context));
      },
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (_) {
          FirebaseFirestore.instance.collection('vc').doc(callID).set(
              {'VideoCall': false});
              return Navigator.pop(context);
        },
    );
  }
}
