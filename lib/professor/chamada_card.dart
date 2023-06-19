import 'package:chamada/models/aluno.dart';
import 'package:chamada/shared/environment.dart';
import 'package:flutter/material.dart';

class AlunoCard extends StatelessWidget {
  final Aluno aluno;

  const AlunoCard(
      this.aluno, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              child: Image.network(
                "${Environment.BASE_URL}/alunos/${aluno.alunoId}/foto",
                fit: BoxFit.cover,
                height: double.infinity,
                // When image is loading from the server it takes some time
                // So we will show progress indicator while loading
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                // When dealing with networks it completes with two states,
                // complete with a value or completed with an error,
                // So handling errors is very important otherwise it will crash the app screen.
                // I showed dummy images from assets when there is an error, you can show some texts or anything you want.
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset("images/placeholder.jpeg");
                  },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aluno.nome,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  aluno.ra ?? "RA",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  aluno.curso ?? "Curso",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}