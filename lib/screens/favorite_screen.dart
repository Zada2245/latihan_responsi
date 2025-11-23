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
              return Dismissible(
                key: Key(amiibo.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  provider.removeFavorite(amiibo.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${amiibo.name} removed from favorites.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: AmiiboCard(amiibo: amiibo),
              );
            },
          );
        },
      ),
    );
  }
}
