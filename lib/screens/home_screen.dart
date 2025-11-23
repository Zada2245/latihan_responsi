import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/amiibo_provider.dart';
import '../widgets/amiibo_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nintendo Amiibo List")),
      body: Consumer<AmiiboProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.amiibos.isEmpty) {
            return const Center(child: Text("No Data Available"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: provider.amiibos.length,
            itemBuilder: (context, index) {
              return AmiiboCard(amiibo: provider.amiibos[index]);
            },
          );
        },
      ),
    );
  }
}
