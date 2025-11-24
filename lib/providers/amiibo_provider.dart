import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart'; // Import Hive
import '../models/amiibo_model.dart';
import '../constants/api_constants.dart';

class AmiiboProvider with ChangeNotifier {
  List<Amiibo> _amiibos = [];
  bool _isLoading = false;

  // Mengakses box yang sudah dibuka di main.dart
  final Box<Amiibo> _favoritesBox = Hive.box<Amiibo>('favoritesBox');

  List<Amiibo> get amiibos => _amiibos;

  // Mengambil data favorite langsung dari Hive Box values
  List<Amiibo> get favorites => _favoritesBox.values.toList();

  bool get isLoading => _isLoading;

  AmiiboProvider() {
    fetchAmiibos();
  }

  Future<void> fetchAmiibos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(ApiConstants.getAllAmiibo));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> amiiboList = data['amiibo'];
        _amiibos = amiiboList.map((json) => Amiibo.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(String id) {
    // Cek apakah key (id) ada di dalam box
    return _favoritesBox.containsKey(id);
  }

  void toggleFavorite(Amiibo amiibo) {
    if (isFavorite(amiibo.id)) {
      _favoritesBox.delete(amiibo.id); // Hapus dari Hive
    } else {
      _favoritesBox.put(amiibo.id, amiibo); // Simpan object langsung
    }
    notifyListeners();
  }

  void removeFavorite(String id) {
    _favoritesBox.delete(id);
    notifyListeners();
  }

  // Tidak perlu lagi fungsi _saveFavoritesToStorage atau loadFavorites
  // karena Hive otomatis menyimpannya ke disk (persist).
}
