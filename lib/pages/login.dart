import 'package:flutter/material.dart';
import 'package:gsales_test/services/gsales_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';

void loginUser(String email, String password) async {
  Map<String, String> headers = {};

  Map<String, String> body = {"email": email, "password": password};
  Response response = await post('http://192.168.0.173:5000/login',
      headers: headers, body: body);
  String sessionCookie = response.headers["set-cookie"];

  final prefs = await SharedPreferences.getInstance();
  prefs.setString("session-cookie", sessionCookie);

  response = await get('http://192.168.0.173:5000/pedido/get-list',
      headers: {"cookie": prefs.getString("session-cookie")});
  print(response.body);
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GreenSalesData greenSalesData = GreenSalesData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.greenAccent[400],
            child: Center(
                child: Form(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    child: Text(
                      "GreenSales",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Text(
                      "Acesse a sua conta abaixo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        //TODO: implement validator

                        return null;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withAlpha(80),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withAlpha(80),
                                  width: 0.0)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withAlpha(80),
                                  width: 0.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          border: OutlineInputBorder(),
                          hintText: "Email",
                          hintStyle: TextStyle(
                              color: Colors.white, letterSpacing: 1.0)),
                      style: TextStyle(color: Colors.white),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 20.0),
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: Colors.white,
                      obscureText: true,
                      validator: (value) {
                        //TODO: implement validator

                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha(80),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withAlpha(80), width: 0.0)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withAlpha(80), width: 0.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0)),
                        border: OutlineInputBorder(),
                        hintText: "Senha",
                        hintStyle:
                            TextStyle(color: Colors.white, letterSpacing: 1.0),
                      ),
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () async {
                      int status = await greenSalesData.loginUser(
                          emailController.text, passwordController.text);
                      if (status == 401) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Usuário ou senha incorretos")));
                      } else if (status == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Houve um problema de conexão")));
                      } else if (status != 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erro desconhecido")));
                      }

                      bool isLoggedIn = await greenSalesData.isLoggedIn();
                      if (isLoggedIn) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ))
              ],
            )))));
  }
}
