// ignore_for_file: use_build_context_synchronously, duplicate_ignore, must_be_immutable

import 'package:admin_part/home/customers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/colors.dart';

import '../widgets/golobal_methods.dart';

// ignore: camel_case_types
class UserProfile extends StatefulWidget {
  UserProfile({super.key, required this.uid, required this.collection});
  String uid;
  String collection;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

// ignore: camel_case_types
class _UserProfileState extends State<UserProfile> {
  String _name = "";
  String _email = "";

  String role = "";
  String _phonenumber = "";
  var _imageP = "";
  XFile? imgXFile;
  final GlobalMethods _globalMethods = GlobalMethods();

  void _getData() async {
    try {
      final DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.uid)
          .get();
      if (mounted) {
        setState(() {
          _name = userDocs.get('name');
          _email = userDocs.get('email');
          _imageP = userDocs.get('image');
          _phonenumber = userDocs.get('phonenumber');
          role = userDocs.get('role');
        });
      }
    } catch (e) {
      if (mounted) {
        _globalMethods.showDialogues(context, e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }


  logoutMessage() async {
    return (await showDialog(
            context: context,
            builder: (context) {
              // bool isLoading = false;
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: widget.collection == "inactive users"
                    ? const Text('Do you want to activate this user?')
                    : const Text('Do you want to inactive this user?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                      onPressed: () async {
                        // setState(() {
                        //   isLoading = true;
                        // });
                        var result = await FirebaseFirestore.instance
                            .collection(widget.collection)
                            .doc(widget.uid)
                            .get();
                        await FirebaseFirestore.instance
                            .collection(widget.collection == "inactive users"
                                ? "users"
                                : "inactive users")
                            .doc(widget.uid)
                            .set({
                          'id': widget.uid,
                          'name': _name,
                          'email': _email,
                          'phonenumber': _phonenumber,
                          'image': _imageP,
                          'created_at': result["created_at"],
                          "inactive": widget.collection == "inactive users"
                              ? false
                              : true,
                          "about": result["about"],
                          "is_online": result["is_online"],
                          "last_active": result["last_active"],
                          "push_token": result["push_token"],
                          'role': result['role'],
                        });
                        await FirebaseFirestore.instance
                            .collection(widget.collection == "inactive users"
                                ? "inactive users"
                                : "users")
                            .doc(widget.uid)
                            .delete();
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Customer()));
                      },
                      child: const Text('Yes')),
                ],
              );
            })) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _name,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: appbarColor,
        toolbarHeight: 120,
        toolbarOpacity: 0.8,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(
              "User Information",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                    title: const Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                // Divider(),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: Colors.deepOrange,
                    ),
                    title: const Text(
                      'Phone number',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _phonenumber,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                // Divider(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Email',
                      style: TextStyle(
                        // color: Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),

                  child: ListTile(
                    leading: const Icon(
                      Icons.location_city_rounded,
                      color: Colors.teal,
                    ),
                    title: const Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      role,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Setting",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  margin: const EdgeInsets.all(5),

                  child: ListTile(
                    onTap: logoutMessage,
                    leading: const Icon(
                      Icons.block,
                      color: Colors.red,
                    ),
                    title: Text(
                      widget.collection == "inactive users"
                          ? "Activate"
                          : 'Inactive user',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
