// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_element, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:admin_part/authenthication/login.dart';
import 'package:admin_part/widgets/golobal_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../home/main_page.dart';
import '../widgets/custom_shapes.dart';

class Signup extends StatefulWidget {
  static const routeName = '/signup';

  const Signup({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Signup();
  }
}

class _Signup extends State<Signup> {
  var checkBoxValue = false;
  void _chanageVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _fullName = '';

  String _phoneNumber = '';
  File? _image;
  String _url = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  bool showTerms = false;

  Future _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    } else {
      _globalMethods.showDialogues(context, 'Please provide an image');
    }
  }

  bool _isVisible = false;

  void _submitData() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (checkBoxValue) {
        _formKey.currentState!.save();
      }
    }

    try {
      if (_image == null) {
        return _globalMethods.showDialogues(context, 'Please provide an image');
      } else {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('userimages')
            .child('$_fullName.jpg');
        await ref.putFile(_image!);
        _url = await ref.getDownloadURL();

        await _auth.createUserWithEmailAndPassword(
            email: _email.toLowerCase().trim(), password: _password.trim());
        final time = DateTime.now().millisecondsSinceEpoch.toString();

        final User? user = _auth.currentUser;
        final uid = user!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': _fullName,
          'email': _email,
          'phonenumber': _phoneNumber,
          'image': _url,
          'created-at': time,
          'role': 'admin',
          'about': "hello there!",
          'is_online': true,
          'last_active': time,
          'push-token': '',
          'inactive': false,
        });

        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const MainPage()),
            ));
      }
    } catch (e) {
      if (mounted) {
        _globalMethods.showDialogues(context, e.toString());
        print(e);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _numberFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 150,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          shadowColor: const Color.fromARGB(255, 238, 175, 171),
          flexibleSpace: ClipPath(
            clipper: Customeshape(),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 247, 177, 150),
                    Color.fromARGB(255, 241, 169, 159),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 150, 90),
              child: Icon(
                Icons.home_outlined,
                size: 100,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150.0, vertical: 0),
                    child: InkWell(
                      onTap: _getImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.red.shade500,
                        backgroundImage:
                            _image == null ? null : FileImage(_image!),
                        child: Icon(
                          _image == null ? Icons.camera_alt : null,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enter your information.",
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _fullName = value!;
                        });
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_numberFocusNode),
                      key: const ValueKey('name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "user name",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
// keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('number'),
                      validator: (value) {
                        if (value!.length < 10) {
                          return 'Phone number must be 11 units';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'phone number',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    email(),
                    const SizedBox(
                      height: 15,
                    ),
                    password(),
                    const SizedBox(
                      height: 15,
                    ),
                    Signup(context),
                    log_in(context),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget email() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _email = value!;
        });
      },
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      keyboardType: TextInputType.emailAddress,
      key: const ValueKey('email'),
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'email',
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
    );
  }

  Widget password() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      onChanged: (value) {
        setState(() {
          _password = value!;
        });
      },
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_cityFocusNode),
      obscureText: !_isVisible,
      key: const ValueKey('password'),
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return 'Password must be atleast 6 units';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'password',
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

  Widget Signup(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(100)),
            child: MaterialButton(
                onPressed: _submitData,
// Navigator.push(context,
// MaterialPageRoute(builder: (context) => ProductMainPage()));

                child: const Center(
                    child: Text("SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center))));
  }

  Widget log_in(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "I have an account. ",
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 2,
        ),
        GestureDetector(
          child: const Text(
            " login",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
        ),
      ],
    );
  }
}
