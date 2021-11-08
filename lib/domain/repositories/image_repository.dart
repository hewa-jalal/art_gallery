import 'package:art_gallery/core/failures/failures.dart';
import 'package:art_gallery/domain/entities/image_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ImageRepository {
  Future<Either<Failure, List<ImageEntity>>> getImages();
  Future<Either<Failure, void>> uploadImage();
}
