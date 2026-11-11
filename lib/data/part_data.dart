import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/spare_part.dart';

class PartData {
  static Future<List<SparePart>> loadParts() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/spare_parts.json');

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map((item) => SparePart.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}