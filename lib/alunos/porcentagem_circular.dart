import 'package:flutter/material.dart';

class PorcentagemCircular extends StatelessWidget {
  final double percentual;

  const PorcentagemCircular({required this.percentual});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                value: percentual / 100,
                strokeWidth: 5,
                backgroundColor: Colors.grey,
                color: Colors.blue,
              ),
            ),
          ),
          Center(
            child: Text(
              "${percentual.round()}%",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
