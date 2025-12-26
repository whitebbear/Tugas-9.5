import 'package:flutter/material.dart';
import '../../core/services/product_service.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product; // Jika null = Mode Tambah, Jika ada isi = Mode Edit

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  
  // Controller form
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  String _selectedCategory = 'Beverages';
  bool _isLoading = false;

  // Daftar kategori (bisa disamakan dengan products_data.dart)
  final List<String> _categories = ['Beverages', 'Brewed Coffee', 'Blended Coffee'];

  @override
  void initState() {
    super.initState();
    // Isi form jika mode edit
    _titleController = TextEditingController(text: widget.product?['title'] ?? '');
    _priceController = TextEditingController(text: widget.product?['price']?.toString() ?? '');
    
    // Set kategori awal jika mode edit
    if (widget.product != null && _categories.contains(widget.product!['category'])) {
      _selectedCategory = widget.product!['category'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success;
    final title = _titleController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (widget.product == null) {
      // Mode Tambah
      success = await _productService.addProduct(title, price, _selectedCategory);
    } else {
      // Mode Edit
      // Pastikan ID dikirim (widget.product!['id'])
      success = await _productService.updateProduct(
        widget.product!['id'], 
        title,
        price,
        _selectedCategory,
      );
    }

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.product == null ? 'Produk berhasil ditambah!' : 'Produk berhasil diupdate!')),
        );
        Navigator.pop(context, true); // Kembali ke halaman sebelumnya dengan sinyal 'true' (artinya perlu refresh)
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan produk. Cek koneksi atau coba lagi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Informasi Produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                
                // Input Nama
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Input Harga
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Harga (\$)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value!.isEmpty ? 'Harga wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Dropdown Kategori
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E2A47),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text(
                          'SIMPAN', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}