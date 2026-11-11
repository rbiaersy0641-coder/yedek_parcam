
import 'package:flutter/material.dart';
import '../models/spare_part.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    this.onAddToCart,
  });

  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

final part = arguments['part'] as SparePart;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Parça detayı',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFFF7F8FA),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: part.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                part.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            part.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF8792A0),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            part.name,
            style: const TextStyle(
              color: Color(0xFF182230),
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            part.formattedPrice,
            style: const TextStyle(
              color: Color(0xFFF36B43),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8EBEF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF23856D),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Örnek uyumluluk bilgisi',
                        style: TextStyle(
                          color: Color(0xFF182230),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        part.device,
                        style: const TextStyle(
                          color: Color(0xFF687484),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ürün hakkında',
            style: TextStyle(
              color: Color(0xFF182230),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bu örnek katalog ekranında parça türünü ve uyumlu cihaz '
            'bilgisini inceleyebilirsin. Gerçek ürün ve uyumluluk bilgileri '
            'katalog hazırlanırken doğrulanacaktır.',
            style: TextStyle(
              color: Color(0xFF687484),
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: () {
            onAddToCart?.call();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ürün sepete eklendi.'),
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart_rounded),
          label: const Text('Sepete ekle'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFF36B43),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
