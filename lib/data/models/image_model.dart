import 'package:art_gallery/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  final String name;
  final String downloadUrl;

  ImageModel({
    required this.name,
    required this.downloadUrl,
  }) : super(
          name: name,
          downloadUrl: downloadUrl,
        );
}
