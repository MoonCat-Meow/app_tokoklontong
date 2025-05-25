import 'package:app_tokoklontong/models/product_model.dart';
import 'package:get/get.dart';
// import 'package:app_tokoklontong/models/product.dart';
import 'package:app_tokoklontong/services/product_service.dart';

class ProductProvider extends GetxController {
  final ProductService _productService = ProductService();

  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxString selectedCategory = 'Semua'.obs;

  final List<String> categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Bumbu Dapur',
    'Kebutuhan Rumah',
    'Perawatan',
    'Lainnya',
  ];

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  // Load semua produk
  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final productList = await _productService.getAllProducts();
      products.assignAll(productList);
      filterProducts();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter produk berdasarkan kategori dan pencarian
  void filterProducts() {
    List<ProductModel> filtered = products;

    // Filter berdasarkan kategori
    if (selectedCategory.value != 'Semua') {
      filtered =
          filtered
              .where((product) => product.category == selectedCategory.value)
              .toList();
    }

    // Filter berdasarkan pencarian
    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (product) =>
                    product.name.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    product.description.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ),
              )
              .toList();
    }

    filteredProducts.assignAll(filtered);
  }

  // Set kategori filter
  void setCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  // Set query pencarian
  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterProducts();
  }

  // Tambah produk baru
  Future<bool> addProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String unit,
    required int userId,
  }) async {
    try {
      final success = await _productService.addProduct(
        name: name,
        description: description,
        price: price,
        stock: stock,
        category: category,
        unit: unit,
        userId: userId,
      );

      if (success) {
        await loadProducts(); // Refresh data
        Get.snackbar(
          'Sukses',
          'Produk berhasil ditambahkan',
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah produk: $e');
      return false;
    }
  }

  // Update stok produk
  Future<bool> updateStock(int productId, int newStock) async {
    try {
      final success = await _productService.updateProductStock(
        productId,
        newStock,
      );

      if (success) {
        // Update local data
        final index = products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          products[index] = products[index].copyWith(
            stock: newStock,
            updatedAt: DateTime.now(),
          );
          filterProducts();
        }
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal update stok: $e');
      return false;
    }
  }

  // Tambah stok
  Future<void> addStock(int productId, int amount) async {
    final product = products.firstWhere((p) => p.id == productId);
    final newStock = product.stock + amount;

    final success = await updateStock(productId, newStock);
    if (success) {
      Get.snackbar(
        'Sukses',
        'Stok berhasil ditambah +$amount',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      );
    }
  }

  // Kurangi stok
  Future<void> reduceStock(int productId, int amount) async {
    final product = products.firstWhere((p) => p.id == productId);
    final newStock = (product.stock - amount).clamp(0, double.infinity).toInt();

    final success = await updateStock(productId, newStock);
    if (success) {
      Get.snackbar(
        'Sukses',
        'Stok berhasil dikurangi -$amount',
        backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.1),
      );
    }
  }

  // Update produk
  Future<bool> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String unit,
  }) async {
    try {
      final success = await _productService.updateProduct(
        id: id,
        name: name,
        description: description,
        price: price,
        stock: stock,
        category: category,
        unit: unit,
      );

      if (success) {
        await loadProducts();
        Get.snackbar(
          'Sukses',
          'Produk berhasil diupdate',
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal update produk: $e');
      return false;
    }
  }

  // Hapus produk
  Future<bool> deleteProduct(int productId) async {
    try {
      final success = await _productService.deleteProduct(productId);

      if (success) {
        products.removeWhere((p) => p.id == productId);
        filterProducts();
        Get.snackbar(
          'Sukses',
          'Produk berhasil dihapus',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal hapus produk: $e');
      return false;
    }
  }

  // Get produk dengan stok rendah
  List<ProductModel> getLowStockProducts() {
    return products.where((product) => product.stock <= 5).toList();
  }

  // Get total value inventory
  double getTotalInventoryValue() {
    return products.fold(
      0.0,
      (total, product) => total + (product.price * product.stock),
    );
  }
}
