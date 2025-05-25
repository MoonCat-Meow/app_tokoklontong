import 'package:app_tokoklontong/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:app_tokoklontong/models/product.dart';

class ProductService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mengambil semua produk
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _client
          .from('products')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Menambah produk baru
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
      final resepon = await _client.from('products').insert({});

      if (resepon.error != null) {
        print('Gagal menambahkan produk: ${resepon.error!.message}');
      } else {
        print('Produk berhasil ditambahkan');
      }

      return true;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Update stok produk
  Future<bool> updateProductStock(int productId, int newStock) async {
    try {
      await _client
          .from('products')
          .update({
            'stock': newStock,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', productId);

      return true;
    } catch (e) {
      print('Error updating product stock: $e');
      return false;
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
      await _client
          .from('products')
          .update({
            'name': name,
            'description': description,
            'price': price,
            'stock': stock,
            'category': category,
            'unit': unit,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Hapus produk
  Future<bool> deleteProduct(int productId) async {
    try {
      await _client.from('products').delete().eq('id', productId);
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Cari produk berdasarkan nama atau kategori
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .or('name.ilike.%$query%,category.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
