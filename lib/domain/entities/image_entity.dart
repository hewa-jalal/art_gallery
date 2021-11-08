import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String name;
  final String downloadUrl;

  ImageEntity({
    required this.name,
    required this.downloadUrl,
  });

  @override
  List<Object?> get props => [name, downloadUrl];

  @override
  bool get stringify => true;
}
