import 'package:flutter/material.dart';

import '../models/spare_part.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.items,
    required this.onCartChanged,
    required this.onCheckout,
  });

  final List<SparePart> items;
  final ValueChanged<List<SparePart>> onCartChanged;
  final VoidCallback onCheckout;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<SparePart> _items;

  @override
  void initState() {
    super.initState();
    _items = List<SparePart>.of(widget.items);
  }

  void _increase(SparePart part) {
    setState(() {
      _items.add(part);
    });
    widget.onCartChanged(List<SparePart>.unmodifiable(_items));
  }

  void _decrease(SparePart part) {
    final index = _items.indexWhere((item) => item.name == part.name);

    if (index == -1) return;

    setState(() {
      _items.removeAt(index);
    });
    widget.onCartChanged(List<SparePart>.unmodifiable(_items));
  }

  @override
  Widget build(BuildContext context) {
    final uniqueParts = <SparePart>[];

    for (final item in _items) {
      if (!uniqueParts.any((part) => part.name == item.name)) {
        uniqueParts.add(item);
      }
    }

    final total = _items.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF7F8FA),
        surfaceTintColor: Colors.transparent,
      ),
      body: _items.isEmpty
          ? _buildEmptyCart()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Text(
                  '${_items.length} ürün sepetinde',
                  style: const TextStyle(
                    color: Color(0xFF687484),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                for (final part in uniqueParts) ...[
                  _CartItemCard(
                    part: part,
                    quantity: _items
                        .where((item) => item.name == part.name)
                        .length,
                    onIncrease: () => _increase(part),
                    onDecrease: () => _decrease(part),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
      bottomNavigationBar: _items.isEmpty ? null : _buildCheckoutBar(total),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8DF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 38,
                color: Color(0xFFF36B43),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Sepetin şimdilik boş',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF182230),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cihazına uygun parçaları keşfetmeye devam edebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF687484),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kataloğa dön'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(double total) {
    final formattedTotal =
        '₺${total.toStringAsFixed(2).replaceAll('.', ',')}';

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8EBEF)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Toplam',
                    style: TextStyle(
                      color: Color(0xFF687484),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  formattedTotal,
                  style: const TextStyle(
                    color: Color(0xFF182230),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.onCheckout,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Örnek siparişi tamamla'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF36B43),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.part,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  final SparePart part;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EBEF)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: part.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
  padding: const EdgeInsets.all(7),
  child: Image.asset(
    part.imagePath,
    fit: BoxFit.contain,
  ),
),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: const TextStyle(
                    color: Color(0xFF182230),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  part.formattedPrice,
                  style: const TextStyle(
                    color: Color(0xFFF36B43),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      onPressed: onDecrease,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      onPressed: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 17, color: const Color(0xFF364152)),
      ),
    );
  }
}