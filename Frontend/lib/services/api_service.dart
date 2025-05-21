import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> analyzeImage(String imagePath, String category) async {
    try {
      final uri = Uri.parse('https://your-api-endpoint.com/analyze'); // Replace with your actual endpoint
      final request = http.MultipartRequest('POST', uri)
        ..fields['category'] = category
        ..files.add(await http.MultipartFile.fromPath('image', imagePath));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to analyze image');
      }
    } catch (e) {
      print('API error: $e');
      return {
        'safetyLevel': 0,
        'ingredients': [
          {
            'name': 'No Ingredients Detected',
            'safety': 'Unknown',
            'description': '',
          }
        ],
        'safetyInfo': {
          'label': 'Invalid Image',
          'description': 'Unable to detect ingredients.',
          'color': '#9E9E9E',
        }
      };
    }
  }
}

