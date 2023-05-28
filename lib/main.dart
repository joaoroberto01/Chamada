// import 'package:chamada/aulas_admin.dart';
// import 'package:chamada/lista_aulas.dart';
// import 'package:chamada/tela_admin.dart';
// import 'package:chamada/tela_aulas.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Minha App Flutter',
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
//
//   static List<Widget> _widgetOptions = <Widget>[
//     const Text('Tela Home'),
//     TelaAulas(),
//     AulasAdmin(),
//     AulasScreen()
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Aulas',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.security),
//             label: 'Admin',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_balance),
//             label: 'Prof',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
//

import 'package:chamada/aulas_admin.dart';
import 'package:chamada/lista_aulas.dart';
import 'package:chamada/tela_admin.dart';
import 'package:chamada/tela_aulas.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha App Flutter',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static List<String> _menuTitles = [
    'Home',
    'Aulas',
    'Admin',
    'Prof',
  ];

  static List<IconData> _menuIcons = [
    Icons.home,
    Icons.list,
    Icons.security,
    Icons.account_balance,
  ];

  static List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Tela Home')), // Centralize o texto aqui
    TelaAulas(),
    AulasAdmin(),
    AulasScreen()
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_menuTitles[_selectedIndex]), // Título dinâmico baseado no índice selecionado
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50.0), // Adicione o espaçamento na parte superior
          height: MediaQuery.of(context).size.height, // Define a altura como a altura total da tela
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              for (int i = 0; i < _menuTitles.length; i++)
                Container(
                  color: i == _selectedIndex ? Colors.blue.withOpacity(0.2) : null, // Cor de fundo com opacidade menor para o item selecionado
                  child: ListTile(
                    leading: Icon(
                      _menuIcons[i], // Ícone correspondente ao item do menu
                      size: i == _selectedIndex ? 30 : 24, // Tamanho do ícone maior para o item selecionado
                      color: i == _selectedIndex ? Colors.blueAccent : Colors.black, // Cor do ícone diferente para o item selecionado
                    ),
                    title: Text(
                      _menuTitles[i],
                      style: TextStyle(
                        fontWeight: i == _selectedIndex ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}

