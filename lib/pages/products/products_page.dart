import 'package:flutter/material.dart';
import '../../data/products_data.dart'; // Tetap dipakai hanya untuk list 'categories'
import '../../core/services/product_service.dart';
import 'detail_product_page.dart';
import 'product_form_page.dart'; // Import halaman form
import '../cart/cart_page.dart';

class ProductsPage extends StatefulWidget {
  final String? selectedCategory;

  const ProductsPage({super.key, this.selectedCategory});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  late String selectedCategory;
  String searchQuery = '';
  
  List<Map<String, dynamic>> _allProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory ?? 'Beverages';
    _fetchProducts();
  }

  // Ambil data dari backend
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final products = await _productService.getProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi Hapus Produk
  Future<void> _deleteProduct(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      bool success = await _productService.deleteProduct(id);
      if (success) {
        _fetchProducts(); // Refresh list
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus')));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus produk')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter lokal
    final filteredProducts = _allProducts.where((product) {
      final title = product['title'].toString().toLowerCase();
      final matchesSearch = title.contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || product['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Products',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _fetchProducts,
              ),
            ],
          ),
        ),
      ),
      
      // Tombol Tambah Produk (+)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3E2A47),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormPage()),
          );
          if (refresh == true) _fetchProducts();
        },
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3E2A47)))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text("Gagal memuat data:\n$_errorMessage", textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _fetchProducts, child: const Text("Coba Lagi"))
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Search Bar
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) => setState(() => searchQuery = val),
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                    hintText: 'Search here...',
                                    hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
                                    prefixIcon: Icon(Icons.search, color: Color(0xFF9E9E9E), size: 24),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 60, height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.tune, color: Color(0xFF424242), size: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Category Tabs
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isSelected = selectedCategory == category;
                                return GestureDetector(
                                  onTap: () => setState(() => selectedCategory = category),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        category,
                                        style: TextStyle(
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          fontSize: 20,
                                          color: isSelected ? Colors.black : const Color(0xFFBDBDBD),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (isSelected)
                                        Container(
                                          width: 6, height: 6,
                                          decoration: const BoxDecoration(color: Color(0xFFFF9800), shape: BoxShape.circle),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Product Grid
                        filteredProducts.isEmpty 
                        ? const Center(child: Padding(padding: EdgeInsets.only(top: 50), child: Text("Tidak ada produk.")))
                        : GridView.builder(
                            key: ValueKey(selectedCategory + searchQuery),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 80), // Tambah padding bawah agar tidak tertutup FAB
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.55,
                            ),
                            itemBuilder: (context, index) {
                              return _buildProductCard(filteredProducts[index]);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    // Helper gambar
    Widget buildImage() {
      final String imagePath = product['image'] ?? '';
      if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
        );
      } else {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image)),
        );
      }
    }

    return GestureDetector(
      // Tap Biasa: Ke Detail
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
        );
      },
      // Tekan Lama: Menu Edit/Hapus
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Edit Produk'),
                  onTap: () async {
                    Navigator.pop(context);
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductFormPage(product: product)),
                    );
                    if (refresh == true) _fetchProducts();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus Produk'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteProduct(product['id']);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'product-${product['id']}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(width: double.infinity, child: buildImage()),
                      ),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                        child: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product['title'],
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                product['subtitle'] ?? 'Coffee',
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12, fontWeight: FontWeight.w400),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.local_offer_outlined, size: 14, color: Color(0xFF757575)),
                  const SizedBox(width: 4),
                  Text('\$${product['price']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}