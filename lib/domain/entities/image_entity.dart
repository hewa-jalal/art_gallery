import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String name;
  final String downloadUrl;
  final String artistName;

  ImageEntity({
    required this.name,
    required this.artistName,
    required this.downloadUrl,
  });

  @override
  List<Object?> get props => [name, downloadUrl, artistName];

  @override
  bool get stringify => true;
}
