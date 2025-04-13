import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shopping_app/dtos/register_request_dto.dart';
import 'package:shopping_app/pages/login_page.dart';

import '../services/networking.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // class variables
  bool showSpinner = false;
  String firstName = '';
  String lastName = '';
  String username = '';
  String phone = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  // void onTap() async {
  //
  // }

  @override
  Widget build(BuildContext context) {
    // widget variables
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Register with CarryGo',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      firstName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      icon: Icon(Icons.info),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      lastName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      icon: Icon(Icons.info),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Username',
                      icon: Icon(Icons.male),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.mail),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      phone = value;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      icon: Icon(Icons.phone),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.password),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      icon: Icon(Icons.password),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // validate password
                        if (firstName.isEmpty ||
                            lastName.isEmpty ||
                            username.isEmpty ||
                            phone.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')));
                        } else if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please confirm password')));
                        } else if (phone.length < 11) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter 11 digit phone number')));
                        } else {
                          // show the sinner
                          setState(() {
                            showSpinner = true;
                          });

                          // add form data to the registration and dto and invoke the registration method
                          final dto = RegisterRequestDto(
                              firstName: firstName,
                              lastName: lastName,
                              username: username,
                              phone: phone,
                              email: email,
                              password: password);
                          NetworkHelper helper = NetworkHelper();
                          final response = await helper.registerUser(dto);
                          //print("REGISTER: " + response.toString());
                          await Future.delayed(const Duration(seconds: 1));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(response)));
                          // Navigate to the login screen
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return LoginPage();
                            }),
                          );
                          // remove the spinner
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        //minimumSize: const Size(double.infinity, 50),
                        fixedSize: const Size(350, 50),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
