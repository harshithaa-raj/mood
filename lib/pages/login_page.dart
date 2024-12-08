import 'package:flutter/material.dart';
import 'package:flutter_mood/utils/routes.dart';
import 'package:flutter_mood/pages/registration_page.dart'; // Import RegistrationPage

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

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
      return const Color.fromARGB(181, 222, 199, 115); 
    } else if (hour < 17) {
      return const Color.fromARGB(255, 234, 123, 68); 
    } else {
      return const Color.fromARGB(255, 41, 77, 93); 
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
    return Scaffold(
      body: TweenAnimationBuilder(
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
            child: Row(
              children: [
                // Left half with image
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/WhatsApp Image 2024-10-27 at 18.09.40_af277417.jpg",
                    fit: BoxFit.cover, 
                  ),
                ),
                
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildUsernameField(),
                              SizedBox(height: 10),
                              _buildPasswordField(),
                              SizedBox(height: 20),
                              _buildLoginButton(),
                              SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegistrationPage()), // Navigate to RegistrationPage
                                  );
                                },
                                child: Text(
                                  "Don't have an account? Register here",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
              ],
            ),
          );
        },
      ),
    );
  }

  TextFormField _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter username",
        labelText: "Username",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Username cannot be empty";
        }
        return null;
      },
      onChanged: (value) {
        name = value;
        setState(() {});
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter Password",
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the password";
        } else if (value.length < 6) {
          return "Password length must be at least 6 characters";
        }
        return null;
      },
    );
  }

  Material _buildLoginButton() {
    return Material(
      color: Colors.amberAccent,
      borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
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
    );
  }
}
