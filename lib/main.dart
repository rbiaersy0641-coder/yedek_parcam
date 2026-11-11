import 'package:flutter/material.dart';
import 'screens/product_detail_screen.dart';
import 'models/spare_part.dart';
import 'data/part_data.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const YedekParcamApp());
}

class YedekParcamApp extends StatelessWidget {
  const YedekParcamApp({super.key});

  @override
  Widget build(BuildContext context) {
   
return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'YedekParçam',

  theme: ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF36B43),
    ),
    fontFamily: 'Roboto',
  ),

  initialRoute: '/home',

  routes: {
  '/home': (context) => const CatalogHomePage(),

  '/product-detail': (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    
    final onAddToCart = arguments['onAddToCart'] as VoidCallback;

    return ProductDetailScreen(
      onAddToCart: onAddToCart,
    );
  },
},
);

  }
}





class CatalogHomePage extends StatefulWidget {
  const CatalogHomePage({super.key});

  @override
  State<CatalogHomePage> createState() => _CatalogHomePageState();
}

class _CatalogHomePageState extends State<CatalogHomePage> {
  final TextEditingController _searchController = TextEditingController();
@override
void initState() {
  super.initState();
  _loadParts();
}

Future<void> _loadParts() async {
  try {
    final parts = await PartData.loadParts();

    if (!mounted) return;

    setState(() {
      _allParts = parts;
      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    debugPrint('Ürünler yüklenemedi: $e');
  }
}


final List<SparePart> _cartItems = [];
List<SparePart> _allParts = [];
bool _isLoading = true;

  final List<String> _devices = [
    'Xiaomi Robot Vacuum S10',
    'Roborock Q7 Max',
  ];

  final List<String> _categories = ['Tümü', 'Filtre', 'Fırça', 'Paspas'];

  String _selectedDevice = 'Xiaomi Robot Vacuum S10';
  String _selectedCategory = 'Tümü';
  String _searchText = '';

void _addToCart(SparePart part) {
  setState(() {
    _cartItems.add(part);
  });
}

void _openCart() {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CartScreen(
        items: List<SparePart>.unmodifiable(_cartItems),
        onCartChanged: (items) {
          setState(() {
            _cartItems
              ..clear()
              ..addAll(items);
          });
        },
        onCheckout: () {
          setState(() {
            _cartItems.clear();
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Örnek sipariş tamamlandı.')),
          );
        },
      ),
    ),
  );
}

  List<SparePart> get _visibleParts {
    return _allParts.where((part)  {
      final matchesDevice = part.device == _selectedDevice;
      final matchesCategory =
          _selectedCategory == 'Tümü' || part.category == _selectedCategory;
      final query = _searchText.toLowerCase();
      final matchesSearch = part.name.toLowerCase().contains(query) ||
          part.category.toLowerCase().contains(query) ||
          part.device.toLowerCase().contains(query);

      return matchesDevice && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            _buildHeader(),
            const SizedBox(height: 28),
            const Text(
              'Cihazına uygun parçayı\nkolayca bul.',
              style: TextStyle(
                fontSize: 29,
                height: 1.15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
                color: Color(0xFF182230),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Örnek katalog • Fiyat ve uyumluluk bilgileri demo amaçlıdır.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF788392),
              ),
            ),
            const SizedBox(height: 22),
            _buildDeviceSelector(),
            const SizedBox(height: 14),
            _buildSearchField(),
            const SizedBox(height: 22),
            _buildCategoryFilters(),
            const SizedBox(height: 22),
            _buildResultsHeading(),
            const SizedBox(height: 14),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8DF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.handyman_rounded,
            color: Color(0xFFF36B43),
            size: 23,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'YedekParçam',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: Color(0xFF182230),
          ),
        ),
        const Spacer(),
               IconButton(
          onPressed: _openCart,
          icon: Badge(
            isLabelVisible: _cartItems.isNotEmpty,
            label: Text('${_cartItems.length}'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF364152),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceSelector() {
    return PopupMenuButton<String>(
      initialValue: _selectedDevice,
      onSelected: (device) {
        setState(() {
          _selectedDevice = device;
          _selectedCategory = 'Tümü';
        });
      },
      itemBuilder: (context) {
        return _devices.map((device) {
          return PopupMenuItem<String>(
            value: device,
            child: Text(device),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EBEF)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.smartphone_rounded,
              color: Color(0xFFF36B43),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SEÇİLİ CİHAZIN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                      color: Color(0xFF8993A1),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _selectedDevice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF182230),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF788392),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Parça, marka veya model ara',
        hintStyle: const TextStyle(color: Color(0xFF9AA3AF), fontSize: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF788392),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8EBEF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8EBEF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF36B43), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 39,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF586474),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            selectedColor: const Color(0xFF182230),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF182230)
                  : const Color(0xFFE8EBEF),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeading() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Sana uygun parçalar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF182230),
            ),
          ),
        ),
        Text(
          '${_visibleParts.length} ürün',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF788392),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  
 
Widget _buildProductGrid() {
  if (_visibleParts.isEmpty) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 34,
            color: Color(0xFF9AA3AF),
          ),
          SizedBox(height: 8),
          Text(
            'Bu aramayla eşleşen parça bulamadık.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF586474)),
          ),
        ],
      ),
    );
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _visibleParts.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.68,
    ),
    itemBuilder: (context, index) {
      final part = _visibleParts[index];

      return _ProductCard(
        part: part,
        onTap: () {
          Navigator.of(context).pushNamed(
            '/product-detail',
            arguments: {
              'part': part,
              'onAddToCart': () => _addToCart(part),
            },
          );
        },
      );
    },
  );
}
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.part,
    required this.onTap,
  });

  final SparePart part;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE9EDF1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: part.color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
  padding: const EdgeInsets.all(8),
  child: Image.asset(
    part.imagePath,
    fit: BoxFit.contain,
  ),
),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'UYUMLU',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF23856D),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                part.category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                  color: Color(0xFF8A95A3),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                part.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF182230),
                ),
              ),
              const Spacer(),
              Text(
                part.formattedPrice,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF36B43),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}