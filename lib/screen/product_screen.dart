import 'package:app_tokoklontong/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_tokoklontong/providers/product_provider.dart';
import 'package:app_tokoklontong/providers/auth_provider.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final ProductProvider productProvider = Get.put(ProductProvider());
  final AuthProvider authProvider = Get.find<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAddProductDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Produk',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search dan Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => productProvider.setSearchQuery(value),
                ),
                const SizedBox(height: 12),

                // Category Filter
                Obx(
                  () => SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = productProvider.categories[index];
                        final isSelected =
                            productProvider.selectedCategory.value == category;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected:
                                (_) => productProvider.setCategory(category),
                            backgroundColor: Colors.white,
                            selectedColor: Colors.teal.shade100,
                            checkmarkColor: Colors.teal,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: Obx(() {
              if (productProvider.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (productProvider.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada produk',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _showAddProductDialog(context),
                        child: const Text('Tambah Produk Pertama'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => productProvider.loadProducts(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: productProvider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.filteredProducts[index];
                    return _buildProductCard(context, product);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final isLowStock = product.stock <= 5;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border:
              isLowStock
                  ? Border.all(color: Colors.red.shade300, width: 2)
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and stock status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isLowStock
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isLowStock ? 'Stok Rendah' : 'Tersedia',
                      style: TextStyle(
                        color:
                            isLowStock
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Product Info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp ${_formatCurrency(product.price)}/${product.unit}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.category,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Stock Controls
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          'Stok',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.stock}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                isLowStock
                                    ? Colors.red.shade600
                                    : Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStockButton(
                              icon: Icons.remove,
                              color: Colors.red,
                              onPressed:
                                  () => _showStockDialog(
                                    context,
                                    product,
                                    isAdd: false,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            _buildStockButton(
                              icon: Icons.add,
                              color: Colors.green,
                              onPressed:
                                  () => _showStockDialog(
                                    context,
                                    product,
                                    isAdd: true,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showEditProductDialog(context, product),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          () => _showDeleteConfirmation(context, product),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Hapus'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  void _showStockDialog(
    BuildContext context,
    ProductModel product, {
    required bool isAdd,
  }) {
    final TextEditingController amountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(isAdd ? 'Tambah Stok' : 'Kurangi Stok'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            Text('Stok saat ini: ${product.stock}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                if (isAdd) {
                  productProvider.addStock(product.id, amount);
                } else {
                  productProvider.reduceStock(product.id, amount);
                }
                Get.back();
              } else {
                Get.snackbar('Error', 'Masukkan jumlah yang valid');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAdd ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(isAdd ? 'Tambah' : 'Kurangi'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    _showProductFormDialog(context, null);
  }

  void _showEditProductDialog(BuildContext context, ProductModel product) {
    _showProductFormDialog(context, product);
  }

  void _showProductFormDialog(BuildContext context, ProductModel? product) {
    final isEdit = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final descController = TextEditingController(
      text: product?.description ?? '',
    );
    final priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    final stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    final unitController = TextEditingController(text: product?.unit ?? '');
    String selectedCategory = product?.category ?? 'Makanan';

    Get.dialog(
      AlertDialog(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok Awal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitController,
                decoration: InputDecoration(
                  labelText: 'Satuan (kg, pcs, liter, dll)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items:
                    productProvider.categories
                        .where((cat) => cat != 'Semua')
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              // Validation
              if (nameController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Nama produk tidak boleh kosong');
                return;
              }

              final price = double.tryParse(priceController.text);
              if (price == null || price <= 0) {
                Get.snackbar('Error', 'Harga harus berupa angka yang valid');
                return;
              }

              final stock = int.tryParse(stockController.text);
              if (stock == null || stock < 0) {
                Get.snackbar('Error', 'Stok harus berupa angka yang valid');
                return;
              }

              if (unitController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Satuan tidak boleh kosong');
                return;
              }

              // Get user ID from auth provider - FIXED: sesuai dengan AuthProvider
              final userId = authProvider.currentUser.value?.id;
              if (userId == null) {
                Get.snackbar(
                  'Error',
                  'User tidak ditemukan. Silakan login kembali',
                );
                return;
              }

              bool success = false;

              if (isEdit) {
                // Update product
                success = await productProvider.updateProduct(
                  id: product.id,
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  price: price,
                  stock: stock,
                  category: selectedCategory,
                  unit: unitController.text.trim(),
                );
              } else {
                // Add new product
                success = await productProvider.addProduct(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  price: price,
                  stock: stock,
                  category: selectedCategory,
                  unit: unitController.text.trim(),
                  userId: userId, // Langsung gunakan userId tanpa konversi
                );
              }

              if (success) {
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: Text(isEdit ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductModel product) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus produk ini?'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${product.category}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    'Stok: ${product.stock} ${product.unit}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              productProvider.deleteProduct(product.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    // Format currency to Indonesian Rupiah format
    String result = amount.toStringAsFixed(0);

    // Add thousand separators
    final RegExp regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(regex, (Match match) => '${match[1]}.');

    return result;
  }
}
