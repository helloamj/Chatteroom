// ignore_for_file: prefer_const_constructors

import 'package:chatteroom/models/ChatRoomModel.dart';
import 'package:chatteroom/models/MessageModel.dart';
import 'package:chatteroom/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../ui/theme.dart';
import 'VideoCallPage.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;
  const ChatRoom(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();
  void sendMessage() async {
    String? message = messageController.text.trim();
    messageController.clear();
    if (message != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        createdon: DateTime.now(),
        seen: false,
        sender: widget.userModel.phonenumber,
        text: message,
      );
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatroom.chatroomid)
          .collection('messages')
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
      widget.chatroom.lastMessage = message;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('vc')
                .doc(widget.chatroom.chatroomid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  DocumentSnapshot datasnapshot =
                      snapshot.data as DocumentSnapshot;

                  final data = snapshot.data?.data()?['VideoCall'] ?? false;
                  if (data == true) {
                    return IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vc')
                              .doc(widget.chatroom.chatroomid)
                              .set({'VideoCall': true});
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => VideoCallPage(
                                      callID: widget.chatroom.chatroomid!,
                                      user_id: widget.userModel.phonenumber!,
                                      user_name: widget.userModel.fullname!)));
                        },
                        icon: const Icon(Icons.video_call,
                            color: Colors.green, size: 30));
                  } else {
                    return IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vc')
                              .doc(widget.chatroom.chatroomid)
                              .set({'VideoCall': true});
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => VideoCallPage(
                                      callID: widget.chatroom.chatroomid!,
                                      user_id: widget.userModel.phonenumber!,
                                      user_name: widget.userModel.fullname!)));
                        },
                        icon: const Icon(Icons.video_call,
                            color: Colors.black, size: 30));
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "An error occured! Please check your internet connection."),
                  );
                } else {
                  return Center(
                    child: Text("Say hi to your new friend"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.targetUser.profilepic!),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.targetUser.fullname}',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${widget.targetUser.phonenumber}',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(widget.chatroom.chatroomid)
                        .collection('messages')
                        .orderBy('createdon', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot datasnapshot =
                              snapshot.data as QuerySnapshot;
                          return ListView.builder(
                            reverse: true,
                            itemCount: datasnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(datasnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                              if (currentMessage.sender !=
                                  widget.userModel.phonenumber) {
                                currentMessage.seen = true;
                                FirebaseFirestore.instance
                                    .collection('chatrooms')
                                    .doc(widget.chatroom.chatroomid)
                                    .collection('messages')
                                    .doc(currentMessage.messageid)
                                    .update(currentMessage.toMap());
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment: (currentMessage.sender ==
                                          widget.userModel.phonenumber)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        constraints: BoxConstraints(
                                            maxWidth: Ui.width! / 2),
                                        margin: EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (currentMessage.sender ==
                                                  widget.userModel.phonenumber)
                                              ? Theme.of(context).primaryColor
                                              : Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    maxLines: null,
                                                    currentMessage.text
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            (currentMessage.sender ==
                                                    widget
                                                        .userModel.phonenumber)
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      (currentMessage.seen ==
                                                              true)
                                                          ? Icon(
                                                              Icons.done_all,
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            )
                                                          : Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "An error occured! Please check your internet connection."),
                          );
                        } else {
                          return Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'Enter message...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontSize: 15,
                                  color: const Color.fromARGB(
                                      172, 119, 119, 119))),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 15),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
