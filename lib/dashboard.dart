import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {"name": "Beras", "price": 12000, "stock": 20},
    {"name": "Minyak Goreng", "price": 15000, "stock": 10},
    {"name": "Gula", "price": 11000, "stock": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Toko Kelontong Makmur')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildCard("Pendapatan Hari Ini", "Rp 250.000", Icons.attach_money),
                _buildCard("Total Produk", "${products.length}", Icons.inventory),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final item = products[index];
                  return ListTile(
                    title: Text(item["name"]),
                    subtitle: Text("Harga: Rp${item["price"]} | Stok: ${item["stock"]}"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
