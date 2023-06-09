import 'package:admin_part/home/customer_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text(
            "Customers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: appbarColor,
          centerTitle: true,
          toolbarHeight: 80,
          toolbarOpacity: 0.8,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("inactive", isNotEqualTo: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                var doc = snapshot.data!.docs;
                return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: doc.map((doc) {
                      return ListTile(
                        // contentPadding: EdgeInsets.symmetric(vertical: 5),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfile(
                                      uid: doc["id"],
                                      collection: "users",
                                    ))),
                        leading: const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.redAccent,
                        ),
                        // tileColor: deepPurple[50],
                        title: Text(
                          doc['name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          doc["phonenumber"],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                        trailing: Text(
                          doc['is_online'] ? "online" : "offline",
                          style: TextStyle(
                            fontSize: 15,
                            color: doc['is_online']
                                ? Colors.red[700]
                                : Colors.blue,
                          ),
                        ),
                      );
                    }).toList());
              } else if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            }));
  }
}
