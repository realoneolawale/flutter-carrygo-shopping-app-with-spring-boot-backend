import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/services/networking.dart';
import 'package:shopping_app/services/sharedpreferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSpinner = false;
  late String usernameOrEmail, password = '';
  void onTap() async {
    // validate the fields
    if (usernameOrEmail.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      setState(() {
        showSpinner = false;
      });
    } else {
      // show the spinner
      setState(() {
        showSpinner = true;
      });
      // attempt the login
      NetworkHelper helper = NetworkHelper();
      dynamic response = await helper.loginUser(usernameOrEmail, password);
      // to the the product list page or profile page

      if (response == null) {
        //if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('If an account exists, login is invalid.')));
      } else {
        // put the logged in user in the provider
        context.read<CartProvider>().setAuthResponseDto(response);
        context.read<CartProvider>().login();
        // put the user object in shared preferences
        await SharedPreferenceHelper().saveTokenType(response!.tokenType ?? "");
        await SharedPreferenceHelper()
            .saveAccessToken(response.accessToken ?? "");
        await SharedPreferenceHelper().saveId(response.id ?? 0);
        await SharedPreferenceHelper().saveFirstName(response.firstName ?? "");
        await SharedPreferenceHelper().saveUsername(response.username ?? "");
        await SharedPreferenceHelper().saveEmail(response.email ?? "");
        // navigate to the product list page with the user object
        //context.read<NavigationProvider>().setIndex(0);
        context.read<CartProvider>().setTab(0); // or any valid tab index
      }
      // remove the spinner
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget variables
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Login to CarryGo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    usernameOrEmail = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email or username',
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
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      //minimumSize: const Size(double.infinity, 50),
                      fixedSize: const Size(350, 50),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
