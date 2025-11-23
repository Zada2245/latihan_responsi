import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/amiibo_model.dart';
import '../constants/api_constants.dart'; // <--- Pastikan import ini ada dan sesuai path

class AmiiboProvider with ChangeNotifier {
  List<Amiibo> _amiibos = [];
  List<Amiibo> _favorites = [];
  bool _isLoading = false;

  List<Amiibo> get amiibos => _amiibos;
  List<Amiibo> get favorites => _favorites;
  bool get isLoading => _isLoading;

  AmiiboProvider() {
    loadFavorites();
    fetchAmiibos();
  }

  Future<void> fetchAmiibos() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Menggunakan URL dari file constants
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
    return _favorites.any((item) => item.id == id);
  }

  void toggleFavorite(Amiibo amiibo) async {
    if (isFavorite(amiibo.id)) {
      _favorites.removeWhere((item) => item.id == amiibo.id);
    } else {
      _favorites.add(amiibo);
    }
    await _saveFavoritesToStorage();
    notifyListeners();
  }

  void removeFavorite(String id) async {
    _favorites.removeWhere((item) => item.id == id);
    await _saveFavoritesToStorage();
    notifyListeners();
  }

  Future<void> _saveFavoritesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _favorites.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('favorite_amiibos', encodedData);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('favorite_amiibos')) {
      final String? encodedData = prefs.getString('favorite_amiibos');
      if (encodedData != null) {
        final List<dynamic> decodedList = json.decode(encodedData);
        _favorites = decodedList.map((json) => Amiibo.fromJson(json)).toList();
        notifyListeners();
      }
    }
  }
}
