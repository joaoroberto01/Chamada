import 'dart:async';
import 'dart:io';

import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class AlunoImageScreen extends StatefulWidget {
  @override
  _AlunoImageScreenState createState() => _AlunoImageScreenState();
}

class _AlunoImageScreenState extends State<AlunoImageScreen> {

  String? id;
  bool cache = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    id = appState.userId;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 120,
                //localhost:8080/chamada/alunos/82f58a70-eebb-4862-bf4f-4aa60f0ef9a3/foto AssetImage("placeholder.jpeg")
                backgroundImage: AssetImage("images/placeholder.jpeg") ,
                foregroundImage: NetworkImage("${Environment.BASE_URL}/alunos/$id/foto?cache=$cache"),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                onPressed: () {
                  pickImage();
                },
                label: Text('Adicionar Foto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      File imageFile = File(image.path);

      var fileExtension = extension(image.path);
      var stream = ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var uri = Uri.parse("${Environment.BASE_URL}/alunos/${id}/foto");

      var request = MultipartRequest("POST", uri);
      var multipartFile = MultipartFile('file', stream, length, filename: "image$fileExtension");

      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode != 200) return;

      setState(() => cache = false);
      // response.stream.transform().listen((value) {
      //   print(value);
      // });

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AlunoImageScreen()
  ));
}
