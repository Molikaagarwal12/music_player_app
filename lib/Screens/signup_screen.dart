import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/Screens/home_screen.dart';
import 'package:music_player/Screens/login_screen.dart';
import 'package:music_player/main.dart';

import '../resources/auth_repo.dart';
import '../utils/image_picker.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userController.dispose();
    super.dispose();
  }

  Future<void> selectImage(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Uint8List? selectedImage =
                        await pickImage(ImageSource.gallery);
                    setState(() {
                      _image = selectedImage;
                    });
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    Uint8List? selectedImage =
                        await pickImage(ImageSource.camera);
                    setState(() {
                      _image = selectedImage;
                    });
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthRepo().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      userName: userController.text,
      file: _image!,
    );

    print({res});

    setState(() {
      _isLoading = false;
    });

    if (context.mounted) {
      if (res != 'success') {
        showSnackBar(res, context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MiniPlayerWrapper()),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64, backgroundImage: MemoryImage(_image!))
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')),
                  Positioned(
                    top: 80,
                    left: 80,
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo_sharp),
                      onPressed: () => selectImage(context),
                      iconSize: 45,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFieldInput(
                textEditingController: userController,
                hintText: 'Enter your Username',
                type: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFieldInput(
                textEditingController: emailController,
                hintText: 'Enter your email',
                type: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFieldInput(
                textEditingController: passwordController,
                hintText: 'Password',
                isPass: true,
                type: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: signUpUser,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : Container(
                        color: Colors.blue,
                        height: 40,
                        width: 340,
                        child: const Center(
                          child: Text('Sign Up',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Login.",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
