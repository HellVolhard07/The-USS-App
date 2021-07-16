import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/profile_screen.dart';
import 'package:the_uss_project/widgets/auth.dart';

//import 'package:the_uss_project/widgets/show_alert_dialogue.dart';
import 'package:the_uss_project/main.dart';

import '../theme_provider.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _loginNode = FocusNode();

  String email = "";
  String password = "";

  bool isLogin = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _emailNode = FocusNode();
  //   _passwordNode = FocusNode();
  //   _loginNode = FocusNode();
  // }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    void loginFunction() async {
      final form = _loginFormKey.currentState;

      if (!form!.validate()) {
        return;
      }
      form.save();


      setState(() {
        isLogin = true;
      });

      await loginProvider.loginUser(email, password, context);

      //String error = loginProvider.getError;

      //showMyDialog(context, error);

      setState(() {
        isLogin = false;
      });

      
     

    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 325,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/login_background.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurpleAccent,
                            blurRadius: 3,
                            offset: Offset(5, 3),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                onSaved: (fieldEmail) {
                                  setState(() {
                                    email = fieldEmail.toString();
                                  });
                                },
                                focusNode: _emailNode,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (_) {
                                  _emailNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_passwordNode);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                onSaved: (fieldPassword) {
                                  setState(() {
                                    password = fieldPassword.toString();
                                  });
                                },
                                focusNode: _passwordNode,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                obscureText: true,
                                onFieldSubmitted: (_) {
                                  _passwordNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_loginNode);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    !isLogin
                        ? Center(
                            child: ElevatedButton(
                              focusNode: _loginNode,
                              onPressed: () {
                                loginFunction();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.deepPurpleAccent,
                                ),
                                alignment: Alignment.center,
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 40),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
