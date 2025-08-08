import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadTenantConfig(String tenantFileName) async {
  final String jsonString =
      await rootBundle.loadString('lib/tenants/$tenantFileName');
  return json.decode(jsonString);
}