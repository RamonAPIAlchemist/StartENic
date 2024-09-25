import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startenic1/Modelo/modelo_usuario_perfil.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:logging/logging.dart';

final Logger _logger = Logger('ControladorUsuarioPerfil');

class ControladorUsuarioPerfil {
  // Inicializa Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Inicializa el perfil de usuario con todos los campos
  UsuarioPerfil perfilDeUsuario = UsuarioPerfil(
    name: "",
    email: "",
    empresa: "",
    tipoDeUsuario: "",
    ubicacion: "",
    descripcionProducto: "",
  );

  // Método para editar el perfil de usuario local y actualizarlo en Firestore
  Future<void> editUserProfile({
    required String name,
    required String email,
    required String empresa,
    required String tipoDeEmpresa,
    required String ubicacion,
    required String descripcionProducto,
  }) async {
    // Actualiza el perfil local
    perfilDeUsuario = UsuarioPerfil(
      name: name,
      email: email,
      empresa: empresa,
      tipoDeUsuario: tipoDeEmpresa,
      ubicacion: ubicacion,
      descripcionProducto: descripcionProducto,
    );

    // Actualiza el perfil en Firestore
    try {
      await db.collection('usuarios').doc(email).set({
        'name': name,
        'email': email,
        'empresa': empresa,
        'tipoDeUsuario': tipoDeEmpresa,
        'ubicacion': ubicacion,
        'descripcionProducto': descripcionProducto,
      });
      _logger.info("Perfil actualizado correctamente en Firestore");
    } catch (imprimir) {
      _logger.severe("Error al actualizar el perfil en Firestore: $imprimir");
    }
  }

  // Método para obtener el perfil de usuario actual desde Firestore
  Future<UsuarioPerfil> getUserProfile(String email) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection('usuarios').doc(email).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        perfilDeUsuario = UsuarioPerfil(
          name: data['name'] ?? "",
          email: data['email'] ?? "",
          empresa: data['empresa'] ?? "",
          tipoDeUsuario: data['tipoDeUsuario'] ?? "",
          ubicacion: data['ubicacion'] ?? "",
          descripcionProducto: data['descripcionProducto'] ?? "",
        );
      }
    } catch (imprimir) {
      _logger.severe("Error al obtener el perfil de Firestore: $imprimir");
    }

    return perfilDeUsuario;
  }
}
