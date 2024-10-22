import 'package:flutter/material.dart';
import 'package:flutter_mood/utils/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  // Function to determine greeting and background based on time of day
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning, $name! Ready for a positive day?";
    } else if (hour < 17) {
      return "Good Afternoon, $name! Keep up the energy!";
    } else {
      return "Good Evening, $name! Wind down and relax!";
    }
  }

  Color getBackgroundColor() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return const Color.fromARGB(181, 222, 199, 115); // Morning - Light Blue
    } else if (hour < 17) {
      return const Color.fromARGB(255, 234, 123, 68); // Afternoon - Orange
    } else {
      return const Color.fromARGB(255, 41, 77, 93); // Evening/Night - Purple
    }
  }

  Future<void> moveToHome(BuildContext context) async {

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        changeButton = true;
      });
      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          // Background with animated gradient color based on time
          TweenAnimationBuilder(
            tween: ColorTween(begin: Colors.blue, end: getBackgroundColor()),
            duration: Duration(seconds: 3),
            builder: (context, Color? color, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color!, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          // Login Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Personalized Greeting with Time-based Message
                SizedBox(height: 60),
                Text(
                  getGreeting(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/vibecheck.webp",
                  fit: BoxFit.cover,
                  height: 500,
                  width: 500,
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter username",
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "username cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter the password";
                            } else if (value.length != 6) {
                              return "password length must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Login Button with Animated Transformation
                        Material(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(
                              changeButton ? 50 : 8),
                          child: InkWell(
                            onTap: () => moveToHome(context),
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              width: changeButton ? 50 : 150,
                              height: 50,
                              alignment: Alignment.center,
                              child: changeButton
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}