class ImagesModel {
  final List<String> images;

  ImagesModel({required this.images});

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
      images: json['images'] as List<String>,
    );
  }
}