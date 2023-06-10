// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_element, prefer_final_fields, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, avoid_print

import 'package:admin_part/authenthication/forget_pasword.dart';
import 'package:admin_part/authenthication/signup.dart';
import 'package:admin_part/home/main_page.dart';
import 'package:admin_part/widgets/golobal_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_shapes.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  const Login({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  void _chanageVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();

  String _email = '';
  String _password = '';

  bool _isVisible = false;
  bool _isLoading = false;

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        final newUser = await _auth.signInWithEmailAndPassword(
            email: _email.toLowerCase().trim(),
            password: _password.toLowerCase().trim());
        if (newUser != null) {
          final doc = await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

          if (doc.exists) {
            if (doc["role"] == "admin") {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
              print("logged in");
            } else {
              _globalMethods.showDialogues(
                  context, "Account is not admin account.");
            }
          } else {
            _globalMethods.showDialogues(
                context, "Account is blocked! Contact customer services.");
          }
        }
// print("logged in");
      } catch (e) {
        if (mounted) {
          _globalMethods.showDialogues(context, e.toString());
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 350,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          flexibleSpace: ClipPath(
            clipper: Customeshape(),
            child: Container(
              height: 360,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 238, 175, 171),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 120, 40),
              child: Column(
                children: [
                  const Icon(
                    Icons.home_outlined,
                    size: 180,
                    color: Colors.red,
                  ),
                  Row(
                    children: const [
                      Icon(Icons.home_rounded, color: Colors.red),
                      Icon(Icons.home_rounded),
                      Icon(Icons.home_rounded, color: Colors.red),
                      Icon(Icons.home_rounded),
                      Icon(Icons.home_rounded, color: Colors.red),
                      Icon(Icons.home_rounded),
                      Icon(Icons.home_rounded, color: Colors.red),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Please enter your login credentials",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        userInputWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        passwordInputWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        forgetPassword(),
// const SizedBox(
// height: 3,
// ),
                        loginButton(context),
// const SizedBox(
// height: 3,
// ),
                        Sign_up(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget userInputWidget() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red),
        ),
        prefixIcon: const Icon(
          Icons.email,
          color: Colors.redAccent,
        ),
      ),
      onSaved: (value) {
        _email = value!;
      },
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      key: const ValueKey('email'),
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget passwordInputWidget() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      onSaved: (value) {
        _password = value!;
      },
      onEditingComplete: _submitData,
      obscureText: !_isVisible,
      key: const ValueKey('password'),
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return 'Password must be atleast 6 units';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red),
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.redAccent,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Widget forgetPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResetPassword()));
        },
        child: Container(
          alignment: Alignment.bottomRight,
          child: const Text(
            "forgot password?",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext _context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
            child: MaterialButton(
              onPressed: _submitData,
// Navigator.push(context,
// MaterialPageRoute(builder: (context) => ProductMainPage()));

              child: const Center(
                child: Text("SIGN IN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
          );
  }

  Widget Sign_up(BuildContext _context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Not a member? ",
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 2,
        ),
        GestureDetector(
          child: const Text(
            " Register now.",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Signup()));
          },
        ),
      ],
    );
  }
}
