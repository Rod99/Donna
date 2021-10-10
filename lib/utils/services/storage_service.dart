import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donna/utils/models/user.dart';

class StorageService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future createUser(UserModel user) async {
    await usersCollection.doc(user.id).set(user.toMap());
  }

  Future<UserModel> getUser(String uid) async {
    final userData = await usersCollection.doc(uid).get();
    final userInfo = userData.data();
    print(userInfo);
    return UserModel.fromMap(userInfo);
  }
}