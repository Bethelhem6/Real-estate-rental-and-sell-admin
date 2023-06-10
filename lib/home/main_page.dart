// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin_part/authenthication/login.dart';
import 'package:admin_part/home/customers.dart';
import 'package:admin_part/home/inactive_customers.dart';
import 'package:admin_part/home/reviews.dart';
import 'package:admin_part/user_profile/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/golobal_methods.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int agencies = 0;
  final GlobalMethods _globalMethods = GlobalMethods();

  String _uid = "";
  String _name = "";
  String _email = "";
  String _image = "";

  void _getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    _uid = user!.uid;

    try {
      final DocumentSnapshot userDocs =
          await FirebaseFirestore.instance.collection("users").doc(_uid).get();
      setState(() {
        _name = userDocs.get('name');
        _email = userDocs.get('email');
        _image = userDocs.get('image');
      });
    } catch (e) {
      if (mounted) {
        print(e);
        _globalMethods.showDialogues(context, e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 253, 254, 255),
        appBar: AppBar(
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: appbarColor,
          centerTitle: true,
          toolbarHeight: 70,
          toolbarOpacity: 0.8,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
          ),
        ),
        drawer: Drawer(
          elevation: 5,
          child: ListView(
            // padding: const EdgeInsets.only(bottom: 10),
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: CircleAvatar(
                              // backgroundColor: textPrimaryLightColor,
                              backgroundImage: NetworkImage(_image),
                              radius: 35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _name,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textPrimaryLightColor,
                        ),
                      ),
                      Text(
                        _email,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  )),

              ListTile(
                leading: const Icon(Icons.groups, color: Colors.green),
                title: const Text(
                  ' Customers ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Customer())));
                  // Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text(
                  ' In-active users ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const InactiveUsers())));
                  // Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.person, color: Colors.deepPurple),
                title: const Text(
                  ' My profile ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const MyProfile())));
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: const Text(
                  ' Rate and Review ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const ReviewsWidget())));
                  // Navigator.pop(context);
                },
              ),
              const Divider(
                height: 5,
                color: Colors.deepPurple,
              ),
              // ListTile(
              //   leading: const Icon(Icons.code, color: Colors.blueGrey),
              //   title: const Text(
              //     ' About Developers ',
              //     style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              //   ),
              //   onTap: () {
              //     //   Navigator.push(
              //     //       context,
              //     //       MaterialPageRoute(
              //     //           builder: ((context) => const AboutDevelopers())));
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);

                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    'LogOut',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          // height: 700,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/graph.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                flex: 2,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  children: [
                    Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Birr 10,000,000",
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              "Revenue",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        )),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          var doc = snapshot.data!.docs;
                          return Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Customer(),
                                    ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 250, 212, 210),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      doc.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35),
                                    ),
                                    const Text(
                                      "Customers",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        }),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('reviews')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          var doc = snapshot.data!.docs;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ReviewsWidget(),
                                  ));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 231, 191, 188),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      doc.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35),
                                    ),
                                    const Text(
                                      "Reviews",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                )),
                          );
                        }),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('inactive users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          var doc = snapshot.data!.docs;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InactiveUsers(),
                                  ));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 218, 179, 174),
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      doc.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35),
                                    ),
                                    const Text(
                                      "Inactive Users",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                )),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
