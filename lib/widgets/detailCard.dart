import 'package:flutter/material.dart';

Widget buildDetailCard({
  required String label,
  required String value,
}) {
  return Container(
    width: 200,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(label == 'Height'
                  ? Icons.height
                  : Icons.shopping_bag_outlined),
              Text(value, textAlign: TextAlign.end),
              Text(
                textAlign: TextAlign.end,
                label == 'Height' ? 'm' : 'kg',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.end,
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
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
