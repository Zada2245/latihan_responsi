import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/amiibo_model.dart';
import '../providers/amiibo_provider.dart';
import '../screens/detail_screen.dart';

class AmiiboCard extends StatelessWidget {
  final Amiibo amiibo;
  const AmiiboCard({super.key, required this.amiibo});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AmiiboProvider>(context);
    final isFav = provider.isFavorite(amiibo.id);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(amiibo: amiibo),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.network(
                amiibo.image,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.error),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amiibo.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amiibo.gameSeries,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
                onPressed: () => provider.toggleFavorite(amiibo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
