// ignore_for_file: use_build_context_synchronously

import 'package:chatteroom/firebase/SignInUp.dart';
import 'package:chatteroom/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/ChatRoomModel.dart';
import '../models/UserModel.dart';
import '../provider/SearchPageProvider.dart';
import '../ui/theme.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  const SearchPage({super.key, required this.userModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.phonenumber}", isEqualTo: true)
        .where("participants.${targetUser.phonenumber}", isEqualTo: true)
        .get();
    ChatRoomModel? chatRoom;

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.phonenumber.toString(): true,
          targetUser.phonenumber.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  TextEditingController searchName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: searchName,
                    onChanged: (value) {
                      context.read<SearchPageProvider>().setValue(value.trim());
                    },
                    decoration: InputDecoration(
                        hintText: 'Search Name...',
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
                    height: 40,
                  ),
                  Consumer<SearchPageProvider>(
                      builder: (context, value, child) {
                    if (value.value == "") {
                      return Text("No results found!");
                    } else {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("fullname",
                                isGreaterThanOrEqualTo: value.value,
                                isNotEqualTo: widget.userModel.fullname)
                            .where('fullname', isLessThan: '${value.value}z')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              QuerySnapshot dataSnapshot =
                                  snapshot.data as QuerySnapshot;
                              List<QueryDocumentSnapshot> docs =
                                  dataSnapshot.docs;

                              if (docs.isNotEmpty) {
                                return SizedBox(
                                  height: Ui.height,
                                  width: Ui.width,
                                  child: ListView.builder(
                                    itemCount: docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> userMap = docs[index]
                                          .data() as Map<String, dynamic>;
                                      UserModel searchedUser =
                                          UserModel.fromMap(userMap);

                                      return Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 2,
                                                spreadRadius: 2,
                                                blurStyle: BlurStyle.outer,
                                              )
                                            ]),
                                        width: Ui.width! / 1.1,
                                        child: ListTile(
                                          onTap: () async {
                                            ChatRoomModel? chatroomModel =
                                                await getChatRoomModel(
                                                    searchedUser);
                                            if (chatroomModel != null) {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ChatRoom(
                                                            userModel: widget
                                                                .userModel,
                                                            targetUser:
                                                                searchedUser,
                                                            firebaseUser:
                                                                FirebaseMethods
                                                                    .user!,
                                                            chatroom:
                                                                chatroomModel,
                                                          )));
                                            }
                                          },
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                searchedUser.profilepic!),
                                            backgroundColor: Colors.grey[500],
                                          ),
                                          title: Text(searchedUser.fullname!),
                                          subtitle: Text(searchedUser.bio!),
                                          trailing:
                                              const Icon(Icons.send_rounded),
                                        ),
                                      );
                                    },
                                  ),
                                );

                                // return Text("No results found!");
                              } else {
                                return Text("No results found!");
                              }
                            } else if (snapshot.hasError) {
                              return Text("An error occurred!");
                            } else {
                              return Text("No results found!");
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    }
                  }),
                ],
              ),
            )),
      ),
    );
  }
}
