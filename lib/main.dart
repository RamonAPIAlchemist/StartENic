import 'package:flutter/material.dart';
import 'package:startenic1/Vista/vista_usuario_perfil.dart';
import 'package:startenic1/Modelo/modelo_usuario_perfil.dart';

// Importaciones de Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UsuarioPerfil ejemploPerfil = UsuarioPerfil(
      name: "David Lunar",
      email: "Davide.Lunar@mail.com",
      empresa: "",
      tipoDeUsuario: "Exportador",
      ubicacion: "",
      descripcionProducto: "",
    );

    return MaterialApp(
      title: 'SCREENS_MVC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: VistaUsuarioPerfil(usuarioPerfil: ejemploPerfil),
    );
  }
}

// Si quieres usar Cloud Firestore para mostrar datos desde Firebase:
class FirestoreExample extends StatelessWidget {
  const FirestoreExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Example'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['email']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
