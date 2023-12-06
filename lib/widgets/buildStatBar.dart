import 'package:flutter/material.dart';

Widget buildStatBar(String statName, int value, Color colorSeleccionado) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8.0), // Espaciado inferior
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '$statName: $value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorSeleccionado,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: value / 100, // Normalizar el valor para el progreso (asumiendo un máximo de 100)
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(colorSeleccionado),
          ),
        ),
      ],
    ),
  );
}

