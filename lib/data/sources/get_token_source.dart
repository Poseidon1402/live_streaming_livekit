import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class GetTokenSource {
  Future<String?> call();
}

class GetTokenFromServer implements GetTokenSource {
  final String url;

  GetTokenFromServer(this.url);

  @override
  Future<String?> call() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = response.body;
        return data;
      } else {
        print('Failed to fetch token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      print('Error fetching token: $e');
      return null;
    }
  }
}
