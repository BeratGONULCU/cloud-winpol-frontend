import 'dart:convert';
import 'package:http/browser_client.dart';

class CompanyService {
  static const String baseUrl = "http://192.168.1.38:8000"; // kendi pc ip adresi
  static final BrowserClient _client =
      BrowserClient()..withCredentials = false; 
}
