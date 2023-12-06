import 'package:flutter/material.dart';
Widget buildDetailCard({
  required String label,
  required String value,
}) {
  return SizedBox(
    width: 150,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centra verticalmente
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra horizontalmente
            children: [
              Icon(label == 'Height' ? Icons.height : Icons.shopping_bag_outlined),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                label == 'Height' ? 'm' : 'kg',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildAbilityCard(List abilities) {
  return SizedBox(
    width: 150,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: abilities.map((ability) {
              return Text(
                textAlign: TextAlign.end,
                '• ${ability.name}',
                style: const TextStyle(fontSize: 14),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          const Text(
            textAlign: TextAlign.end,
            'Moves:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
