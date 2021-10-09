class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? imageUrl;

  UserModel({this.id, this.name, this.email, this.imageUrl});

  // Para recibir la información desde Firestore
  factory UserModel.fromMap(map){
    return UserModel(
      id: map['id'].toString(),
      name: map['name'].toString(),
      email: map['email'].toString(),
      imageUrl: map['imageUrl'].toString()
    );
  }
  
  // Para mandar la información a Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl
    };
  }
}