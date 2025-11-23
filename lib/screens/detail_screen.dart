import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/amiibo_model.dart';
import '../providers/amiibo_provider.dart';

class DetailScreen extends StatelessWidget {
  final Amiibo amiibo;
  const DetailScreen({super.key, required this.amiibo});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AmiiboProvider>(context);
    final isFav = provider.isFavorite(amiibo.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Amiibo Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.grey,
            ),
            onPressed: () => provider.toggleFavorite(amiibo),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                amiibo.image,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              amiibo.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1, height: 30),
            _buildDetailRow("Amiibo Series", amiibo.amiiboSeries),
            _buildDetailRow("Character", amiibo.character),
            _buildDetailRow("Game Series", amiibo.gameSeries),
            _buildDetailRow("Type", amiibo.type),
            _buildDetailRow("Head", amiibo.head),
            _buildDetailRow("Tail", amiibo.tail),
            const SizedBox(height: 20),
            const Text(
              "Release Dates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            if (amiibo.release.isNotEmpty)
              ...amiibo.release.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        entry.value ?? '-',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              })
            else
              const Text("No release info"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
