import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/amiibo_provider.dart';
import '../widgets/amiibo_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Consumer<AmiiboProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return const Center(child: Text("No favorites added yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final amiibo = provider.favorites[index];

              // Widget Dismissible untuk fitur Swipe-to-Delete
              return Dismissible(
                // Key harus unik untuk setiap item agar Flutter tidak bingung
                key: Key(amiibo.id),

                // Arah swipe: Horizontal (bisa kiri ke kanan atau kanan ke kiri)
                direction: DismissDirection.horizontal,

                // Tampilan background saat di-swipe
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                // Tampilan background sekunder (saat swipe dari kanan ke kiri)
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                // Fungsi yang dijalankan saat item selesai di-swipe
                onDismissed: (direction) {
                  // 1. Hapus dari database (Hive) melalui Provider
                  provider.removeFavorite(amiibo.id);

                  // 2. Tampilkan pesan (Snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${amiibo.name} removed from favorites.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },

                // Child adalah widget kartu Amiibo itu sendiri
                child: AmiiboCard(amiibo: amiibo),
              );
            },
          );
        },
      ),
    );
  }
}
