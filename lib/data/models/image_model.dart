import 'dart:convert';

import 'package:art_gallery/domain/entities/image_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ImageModel imageFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel extends ImageEntity {
  ImageModel({
    required this.name,
    required this.artistName,
    required this.downloadUrl,
  }) : super(
          name: name,
          artistName: artistName,
          downloadUrl: downloadUrl,
        );

  final String name;
  final String artistName;
  final String downloadUrl;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        name: json["name"],
        artistName: json["artistName"],
        downloadUrl: json["downloadUrl"],
      );

  factory ImageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;

    return ImageModel(
      name: data['name'],
      artistName: data['artistName'],
      downloadUrl: data['downloadUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "artistName": artistName,
        "downloadUrl": downloadUrl,
      };
}
