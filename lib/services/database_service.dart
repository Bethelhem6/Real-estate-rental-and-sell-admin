// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:admin_part/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  var user = FirebaseAuth.instance.currentUser!;

  Future updateUserData(
      String email, String name, String phonenumber) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: name,
        email: email,
        about: "Hey there!",
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '',
        phonenumber: phonenumber,
        role: "owner",
    );

    return await userCollection.doc(uid).set(chatUser.toJson());
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
