import 'package:art_gallery/data/datasources/image_remote_data_source.dart';
import 'package:art_gallery/domain/entities/image_entity.dart';
import 'package:art_gallery/core/failures/failures.dart';
import 'package:art_gallery/domain/repositories/image_repository.dart';
import 'package:dartz/dartz.dart';

class ImageFirebaseRepository implements ImageRepository {
  final ImageRemoteDataSource imageRemoteDataSource;

  ImageFirebaseRepository({required this.imageRemoteDataSource});

  @override
  Future<Either<Failure, List<ImageEntity>>> getImages() async {
    try {
      final images = await imageRemoteDataSource.getImages();
      return right(images);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uploadImage() async {
    try {
      final empty = await imageRemoteDataSource.uploadImage();
      return right(empty);
    } catch (e) {
      return left(ServerFailure());
    }
  }
}
