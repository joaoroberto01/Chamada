import 'package:chamada/admin/admin_cadastro_screen.dart';
import 'package:chamada/admin/admin_disciplinas_screen.dart';
import 'package:chamada/alunos/aluno_aulas_screen.dart';
import 'package:chamada/login_screen.dart';
import 'package:chamada/professor/professor_aulas_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'alunos/aluno_image_screen.dart';
import 'app_state.dart';


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
  VoidCallback? onRefresh;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userTypes =
        (ModalRoute.of(context)!.settings.arguments as String).split(',');
  }



  final List<MenuItem> _menuItems = [
    MenuItem('Foto de perfil', Icons.image, AlunoImageScreen(), ['ALUNO']),
    MenuItem('Cadastro', Icons.person_add, const AdminCadastroScreen(), ['ADMIN']),
    MenuItem('Aulas', Icons.account_balance, ProfessorAulasScreen(), ['PROFESSOR']),
  ];

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();

    final GlobalKey<AlunoAulasScreenState> _alunoAulasScreenState = GlobalKey<AlunoAulasScreenState>();
    final alunoAulasMenuItem = MenuItem('Aulas da semana', Icons.list, AlunoAulasScreen(key: _alunoAulasScreenState), ['ALUNO']);
    alunoAulasMenuItem.onRefresh = () => _alunoAulasScreenState.currentState?.getAulas();
    _menuItems.add(alunoAulasMenuItem);

    final GlobalKey<AdminDisciplinasScreenState> _adminDisciplinasScreenState = GlobalKey<AdminDisciplinasScreenState>();
    final disciplinasMenuItem = MenuItem('Disciplinas', Icons.security, AdminDisciplinasScreen(key: _adminDisciplinasScreenState), ['ADMIN']);
    disciplinasMenuItem.onRefresh = () => _adminDisciplinasScreenState.currentState?.getClasses();
    _menuItems.add(disciplinasMenuItem);

    _menuItems.sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Widget build(BuildContext context) {


    var filteredMenuItems = _menuItems.where((item) {
      return _userTypes.any(item.userTypes.contains);
    }).toList();

    final menuItem = filteredMenuItems[_selectedIndex];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(menuItem.title),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          if (menuItem.onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: menuItem.onRefresh,
            )
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 50.0),
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
                      size: 24,//i == _selectedIndex ? 30 : 24,
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
                        color: i == _selectedIndex
                            ? Colors.blueAccent
                            : Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(
                    Icons.exit_to_app,
                    size: 24,//i == _selectedIndex ? 30 : 24,
                    color: Colors.red
                ),
                title: const Text("Sair", style: TextStyle(fontWeight: FontWeight.normal),),
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          filteredMenuItems[_selectedIndex].screen
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
  VoidCallback? onRefresh;

  MenuItem(this.title, this.icon, this.screen, this.userTypes);
}
