
import 'dart:convert';

import 'package:chamada/aulas_admin.dart';
import 'package:chamada/lista_aulas.dart';
import 'package:chamada/shared/environment.dart';
import 'package:chamada/tela_admin.dart';
import 'package:chamada/tela_aulas.dart';
import 'package:flutter/material.dart';
import 'package:chamada/cadastro_screen.dart';
import 'package:chamada/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Image_screen.dart';
import 'app_state.dart';

// void main() => runApp(const MyApp());

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha App Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _userTypes = [];
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userTypes = (ModalRoute.of(context)!.settings.arguments as String).split(',');
  }

  static List<MenuItem> _menuItems = [
    MenuItem(
        'Home',
        Icons.home,
        Center(child: Text(
            'Seja bem-vindo',
        )),
        ['ADMIN', 'PROFESSOR', 'ALUNO']),
    MenuItem('Aulas', Icons.list, TelaAulas(), ['ALUNO']),
    MenuItem('Disciplinas', Icons.security, AulasAdmin(), ['ADMIN']),
    MenuItem('Aulas', Icons.account_balance, AulasScreen(), ['PROFESSOR']),
    MenuItem('Cadastro', Icons.person_add, CadastroScreen(), ['ADMIN']),
    MenuItem('Foto', Icons.image, ImageScreen(), ['ALUNO']),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    var filteredMenuItems = _menuItems.where((item) {
      return _userTypes.any(item.userTypes.contains);
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(filteredMenuItems[_selectedIndex].title),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50.0),
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              for (int i = 0; i < filteredMenuItems.length; i++)
                Container(
                  color:
                  i == _selectedIndex ? Colors.blue.withOpacity(0.2) : null,
                  child: ListTile(
                    leading: Icon(
                      filteredMenuItems[i].icon,
                      size: i == _selectedIndex ? 30 : 24,
                      color: i == _selectedIndex
                          ? Colors.blueAccent
                          : Colors.black,
                    ),
                    title: Text(
                      filteredMenuItems[i].title,
                      style: TextStyle(
                        fontWeight: i == _selectedIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else if (_selectedIndex == filteredMenuItems.length - 1) {
                          _onItemTapped(_selectedIndex);
                        }
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          filteredMenuItems[_selectedIndex].screen,
          if (_selectedIndex == 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500, // Cor de fundo em vermelho suave
                  ),
                  child: Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final List<String> userTypes;

  MenuItem(this.title, this.icon, this.screen, this.userTypes);
}
