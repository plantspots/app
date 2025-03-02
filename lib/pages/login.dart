import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/user.dart';
import 'package:plantspots/pages/create_account.dart';
import 'package:plantspots/pages/home.dart';
import 'package:plantspots/utils/vars.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = "";
  // double errorMessagePadding = 0;
  double errorMessageSize = 0; // 0 or 15
  bool buttonEnabled = true;

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      buttonEnabled = false;
      errorMessage = "";
      errorMessageSize = 0;
    });

    if (username == "" || password == "") {
      setState(() {
        errorMessage = "Please Fill All Fields";
        errorMessageSize = 15;
        buttonEnabled = true;
      });
      return;
    }

    loginAPI(username, password).then((res) {
      if (mounted) {
        if (res["status_code"] != 200) {
          setState(() {
            errorMessage = res["error_message"];
            errorMessageSize = 15;
            buttonEnabled = true;
          });
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                  type: PageTransitionType.fade,
                  child: HomePage(
                    hash: res["hash"],
                    username: res["username"],
                    email: res["email"],
                    phone: res["phone"],
                    tier: res["tier"],
                  ),
                  childCurrent: context.currentRoute), (route) {
            return false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   title: const Text("Login")
      // ),
      backgroundColor: softBackgroundColor,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  children: [
                    Text(
                      errorMessage,
                      style: TextStyle(
                          color: Colors.red, fontSize: errorMessageSize),
                    ),
                    TextField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: usernameController,
                      style: const TextStyle(
                        color: softTextColor,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Username",
                      ),
                    ),
                    TextField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(
                        color: softTextColor,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButton(
                        onPressed: buttonEnabled ? login : null,
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(textColor),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontVariations: [FontVariation.weight(500)],
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "or",
                    style: TextStyle(
                      fontVariations: [FontVariation.weight(400)],
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: buttonEnabled
                        ? () {
                            Navigator.of(context).pushAndRemoveUntil(
                                PageTransition(
                                    type: PageTransitionType.rightToLeftJoined,
                                    child: CreateAccountPage(),
                                    childCurrent: context.currentRoute),
                                (route) {
                              return false;
                            });
                          }
                        : null,
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(textColor),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.only(
                              left: 5, right: 0, top: 0, bottom: 0)),
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontVariations: [FontVariation.weight(500)],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Route _createRouteToCreateAccount() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const CreateAccountPage(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1, 0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       final tween = Tween(begin: begin, end: end);
//       final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

//       return SlideTransition(
//         position: tween.animate(curvedAnimation),
//         child: child,
//       );
//     },
//   );
// }
