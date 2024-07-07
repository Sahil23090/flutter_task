import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

import 'home_page.dart';
import 'login_token.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/login'),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      await loginData()
          .setToken(body['token'])
          .then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      ));
    } else {
      setState(() {
        errorMessage = 'Login failed. Please check your credentials.';
      });
    }
  }
  bool isclicked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0,),
                Image.asset('assets/1.jpg'),
                const SizedBox(height: 20.0,),
                const Text("Login",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                const SizedBox(height: 20.0,),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email_rounded)),
                ),
                const SizedBox(height: 10.0,),
                TextField(
                  controller: passwordController,
                  decoration:  InputDecoration(labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_open_rounded),
                      suffixIcon: InkWell(onTap: (){
                        setState(() {
                          isclicked = !isclicked ;
                        });
                      },child:isclicked?  const Icon(Icons.visibility_off) : const Icon(Icons.visibility))),
                  obscureText: isclicked,
                ),
                const SizedBox(height: 10.0,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("forgot passward?",style: TextStyle(color: Colors.blue),)
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    onPressed: login,
                    child: const Text('Login'),
                  ),
                ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 60.0,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New to Logistics?",style: TextStyle(fontSize: 20),),
                    Text(" Register",style: TextStyle(color: Colors.blue,fontSize: 20),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
