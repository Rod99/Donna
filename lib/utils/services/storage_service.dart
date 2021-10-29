import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donna/utils/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future updateUser(Map<String,dynamic> user) async {
    try {
      await usersCollection.doc(user['id'].toString()).update(user);
      Fluttertoast.showToast(msg: 'Cuenta actualizada correctamente.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrió un error al actualizar los datos de tu cuenta, inténtalo nuevamente.');
    }
    
  }
}