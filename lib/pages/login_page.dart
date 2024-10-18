import "package:flutter/material.dart";
import "package:flutter_mood/utils/routes.dart";

class LoginPage extends StatefulWidget {
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  String name ="";
  bool changeButton=false;

  final _formKey =GlobalKey<FormState>();

  moveToHome(BuildContext context) async{
    if(_formKey.currentState?.validate() ?? false){
      setState(() {
        changeButton=true;
      });
      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context,MyRoutes.homeRoute);
      setState(() {
        changeButton=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
        child: SingleChildScrollView(
       child:Column(
        children: [
          Image.asset("assets/images/image.png",
          fit: BoxFit.cover,
          height: 300,
          ),
          SizedBox(
            height:20,
          ),
          Text(
            "WELCOME $name",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height:20
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 32),
            child:Form(key: _formKey, 
            child: Column(
              children: [ 
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter username",
                    labelText: "Username",
                  ),
                
                validator:(value){
                  if(value == null || value.isEmpty){
                    return "username cannot be empty";
                  }
                  return null;
                },
                onChanged:(value){
                  name=value;
                  setState(() {
                    
                  });
                },
                ),
            
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    labelText: "Password",
                  ),
                  obscureText: true, 
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "please enter the password";}
                    else if(value.length!=6){
                      return "password length atleast 6 digits";
                    }
                    return null;
                  },
                 
               ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  color: Colors.amberAccent,
                  borderRadius:
                    BorderRadius.circular(changeButton?50:8),
                  child:InkWell(
                    onTap: ()=>moveToHome(context) ,
                    child:AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: changeButton?50:150,
                      height: 50,
                      alignment: Alignment.center,
                      child: changeButton
                        ?Icon(
                          Icons.done,
                          color:Colors.white,
                      )
                        :Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
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
      
    );
  }
}
