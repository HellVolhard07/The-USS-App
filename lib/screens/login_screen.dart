import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/auth.dart';

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

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
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
                height: mediaQuery.height * 0.4,
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
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width * 0.07,
                  vertical: mediaQuery.height * 0.04,
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
                    SizedBox(height: mediaQuery.height * 0.04),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(mediaQuery.width * 0.025),
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }
                                  if (!value.contains("@")) {
                                    return "Invalid Email";
                                  }
                                  return null;
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
                              padding: EdgeInsets.all(mediaQuery.width * 0.025),
                              child: TextFormField(
                                onSaved: (fieldPassword) {
                                  setState(() {
                                    password = fieldPassword.toString();
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }

                                  return null;
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
                    SizedBox(height: mediaQuery.height * 0.045),
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
                                  color: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
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
                                  themeProvider.isDarkTheme
                                      ? Color(0xffffa265)
                                      : Color(0xffcd885f),
                                ),
                                alignment: Alignment.center,
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: mediaQuery.width * 0.12),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    SizedBox(height: mediaQuery.height * 0.025),
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
