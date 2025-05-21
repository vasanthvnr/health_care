import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String category;
  final Map<String, dynamic> results;
  final Map<String, dynamic> safetyInfo;

  const DetailsScreen({super.key, required this.category, required this.results, required this.safetyInfo});

  Map<String, dynamic> _getIngredientDetails(String name) {
    final details = {
      'Ingredient 1': {
        'safety': 'Safe',
        'description': 'A natural ingredient with moisturizing properties.',
        'concerns': []
      },
      'Ingredient 2': {
        'safety': 'Moderate',
        'description': 'May cause irritation for sensitive skin.',
        'concerns': ['May cause irritation in sensitive individuals']
      },
      'Ingredient 3': {
        'safety': 'Harmful',
        'description': 'Known to cause irritation and potentially harmful effects.',
        'concerns': ['Skin irritation', 'Hormone disruption']
      },
    };
    return details[name] ?? {
      'safety': 'Unknown',
      'description': 'No details available.',
      'concerns': []
    };
  }

  Color _getColor(String safety) {
    switch (safety) {
      case 'Safe':
        return Colors.green;
      case 'Moderate':
        return Colors.orange;
      case 'Harmful':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = results['ingredients'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Analysis')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: safetyInfo['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(safetyInfo['icon'], color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      safetyInfo['label'],
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(safetyInfo['description'], style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              const Text('Ingredient Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...ingredients.map<Widget>((ing) {
                final detail = _getIngredientDetails(ing['name']);
                final color = _getColor(detail['safety']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ing['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                            child: Text(detail['safety'], style: const TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(detail['description'], style: const TextStyle(fontSize: 14)),
                      if (detail['concerns'].isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Potential Concerns:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...detail['concerns'].map<Widget>((c) => Row(
                              children: [
                                const Icon(Icons.warning, size: 16, color: Colors.red),
                                const SizedBox(width: 6),
                                Text(c, style: const TextStyle(fontSize: 14)),
                              ],
                            ))
                      ]
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This analysis is for informational purposes only. Individual reactions may vary.',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

