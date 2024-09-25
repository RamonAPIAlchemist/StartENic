import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuarios() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');

  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();
  
  // ignore: avoid_function_literals_in_foreach_calls
  queryUsuarios.docs.forEach((documento){
    usuarios.add(documento.data());
  });

  return usuarios;
}

//Guardar informacion en la base de datos
Future<void> addUsuarios(String nombreCompleto, String email, String telefono, String ubicacion, String cedula) async{
  await db.collection('usuarios').add({"nombreCompleto": nombreCompleto, "email":email, 'telefono':telefono, 'ubicacion':ubicacion, 'cedula': cedula});
}
