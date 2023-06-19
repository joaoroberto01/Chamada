import 'dart:convert';

import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String login = _loginController.text;
      String senha = _passwordController.text;

      bool isAuthenticated = true;

      if (isAuthenticated) {
        var requestBody = {
          'login': login,
          'senha': senha,
        };

        var url = Uri.parse('${Environment.BASE_URL}/usuarios/login');

        var response = await http.post(
          url,
          body: json.encode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final appState = Provider.of<AppState>(context, listen: false);

          var responseBody = response.body;
          var responseData = json.decode(responseBody);
          var tipo = responseData['tipo'];

          appState.setUserId(responseData['id']);

          print(responseData);
          print(tipo);

          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: tipo,
          );
        } else {
          _mostrarNotificacao(context);
          print('Falha na autenticação');
          print(response.statusCode);
        }
      }
    }
  }

  void _mostrarNotificacao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.close_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Falha na autenticação"),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  'images/rollcall.png', // Substitua pelo caminho da sua imagem
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 60.0), // Espaço adicionado
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        labelText: 'Login',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Digite o login';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Digite a senha';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Fazer login'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 60.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
