import 'package:hive/hive.dart';

// Baris ini wajib ada. Nama file harus sama dengan nama file dart-nya
// tapi berakhiran .g.dart
part 'amiibo_model.g.dart';

@HiveType(typeId: 0) // ID unik untuk tipe objek ini
class Amiibo {
  @HiveField(0)
  final String amiiboSeries;

  @HiveField(1)
  final String character;

  @HiveField(2)
  final String gameSeries;

  @HiveField(3)
  final String head;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String name;

  @HiveField(6)
  final String tail;

  @HiveField(7)
  final String type;

  @HiveField(8)
  final Map<String, dynamic> release;

  Amiibo({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.tail,
    required this.type,
    required this.release,
  });

  factory Amiibo.fromJson(Map<String, dynamic> json) {
    return Amiibo(
      amiiboSeries: json['amiiboSeries'] ?? '-',
      character: json['character'] ?? '-',
      gameSeries: json['gameSeries'] ?? '-',
      head: json['head'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '-',
      tail: json['tail'] ?? '',
      type: json['type'] ?? '-',
      // Mengonversi Map<dynamic, dynamic> ke Map<String, dynamic> untuk Hive
      release: Map<String, dynamic>.from(json['release'] ?? {}),
    );
  }

  // toJson tidak lagi wajib untuk penyimpanan, tapi berguna untuk debugging
  Map<String, dynamic> toJson() {
    return {
      'amiiboSeries': amiiboSeries,
      'character': character,
      'gameSeries': gameSeries,
      'head': head,
      'image': image,
      'name': name,
      'tail': tail,
      'type': type,
      'release': release,
    };
  }

  String get id => head + tail;
}
