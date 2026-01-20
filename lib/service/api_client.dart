import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  static Future<http.Response> get(Uri url) async {
    final token = await AuthStorage.getToken();

    return _client.get(
      url,
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  static Future<http.Response> post(Uri url, {Object? body}) async {
    final token = await AuthStorage.getToken();

    return _client.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: body,
    );
  }

  static Future<http.Response> put(Uri url, {Object? body, required Map<String, String> headers}) async {
    final token = await AuthStorage.getToken();

    return _client.put(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: body,
    );
  }
}
