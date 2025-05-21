import 'package:flutter/material.dart';
import '../app_routes.dart';

class ResultsScreen extends StatelessWidget {
  final String category;
  final String imageUri;
  final Map<String, dynamic> results;

  const ResultsScreen({super.key, required this.category, required this.imageUri, required this.results});

  Map<String, dynamic> _getSafetyInfo(int level) {
    switch (level) {
      case 0:
        return {
          'color': Colors.green,
          'label': 'Healthy',
          'icon': Icons.check_circle,
          'description': 'This product contains safe ingredients.'
        };
      case 1:
        return {
          'color': Colors.orange,
          'label': 'Moderate',
          'icon': Icons.warning,
          'description': 'This product contains some ingredients that may cause issues.'
        };
      case 2:
        return {
          'color': Colors.red,
          'label': 'Unhealthy',
          'icon': Icons.error,
          'description': 'This product contains potentially harmful ingredients.'
        };
      default:
        return {
          'color': Colors.grey,
          'label': 'Unknown',
          'icon': Icons.help,
          'description': 'No analysis available.'
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _getSafetyInfo(results['safetyLevel']);
    final ingredients = results['ingredients'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUri, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(info['icon'], color: info['color']),
                  const SizedBox(width: 8),
                  Text(info['label'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: info['color'])),
                ],
              ),
              const SizedBox(height: 10),
              Text(info['description'], style: const TextStyle(fontSize: 14)),
              const Divider(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Detected Ingredients:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return ListTile(
                      title: Text(ingredient['name']),
                      subtitle: Text(ingredient['description'] ?? ''),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ingredient['safety'] == 'Harmful'
                              ? Colors.red
                              : ingredient['safety'] == 'Moderate'
                                  ? Colors.orange
                                  : Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ingredient['safety'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.details, arguments: {
                    'category': category,
                    'results': results,
                    'safetyInfo': info,
                  });
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View Detailed Analysis'),
                style: ElevatedButton.styleFrom(backgroundColor: info['color']),
              )
            ],
          ),
        ),
      ),
    );
  }
}

