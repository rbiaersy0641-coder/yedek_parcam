
import 'package:flutter/material.dart';

class SparePart {
  const SparePart({
    required this.name,
    required this.category,
    required this.device,
    required this.imagePath,
    required this.price,
    required this.icon,
    required this.color,
  });

  final String name;
  final String category;
  final String device;
  final String imagePath;
  final double price;
  final IconData icon;
  final Color color;

  String get formattedPrice =>
      '₺${price.toStringAsFixed(2).replaceAll('.', ',')}';

  // JSON verisinden SparePart nesnesi oluşturur.
  
factory SparePart.fromJson(Map<String, dynamic> json) {
  return SparePart(
    name: json['name'] as String,
    category: json['category'] as String,
    device: json['device'] as String,
    imagePath: json['imagePath'] as String,
    price: (json['price'] as num).toDouble(),
    icon: _getIcon(json['icon'] as String),
    color: Color(json['color'] as int),
  );
}

Map<String, dynamic> toJson() {
  return {
    'name': name,
    'category': category,
    'device': device,
    'imagePath': imagePath,
    'price': price,
    'icon': _getIconName(icon),
    'color': color.toARGB32(),
  };
}

static IconData _getIcon(String name) {
  switch (name) {
    case 'air':
      return Icons.air_rounded;
    case 'brush':
      return Icons.autorenew_rounded;
    case 'sideBrush':
      return Icons.rotate_right_rounded;
    case 'mop':
      return Icons.water_drop_rounded;
    default:
      return Icons.category_rounded;
  }
}

static String _getIconName(IconData icon) {
  if (icon.codePoint == Icons.air_rounded.codePoint) {
    return 'air';
  }
  if (icon.codePoint == Icons.autorenew_rounded.codePoint) {
    return 'brush';
  }
  if (icon.codePoint == Icons.rotate_right_rounded.codePoint) {
    return 'sideBrush';
  }
  if (icon.codePoint == Icons.water_drop_rounded.codePoint) {
    return 'mop';
  }
  return 'unknown';
}

}
