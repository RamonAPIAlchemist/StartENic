import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startenic1/Modelo/modelo_panel.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class DashboardControlador {
  List<Actividad> actividades = [];
  List<Reunion> reuniones = [];
  List<Acuerdo> acuerdos = [];
  List<Map<String, dynamic>> usuarios =
      []; // Cambiado a Map para almacenar datos de usuarios

  // Métodos para agregar
  void agregarActividad(Actividad actividad) {
    actividades.add(actividad);
  }

  void agregarReunion(Reunion reunion) {
    reuniones.add(reunion);
  }

  void agregarAcuerdo(Acuerdo acuerdo) {
    acuerdos.add(acuerdo);
  }

  // Métodos para actualizar
  void actualizarActividad(int index, Actividad actividad) {
    if (index >= 0 && index < actividades.length) {
      actividades[index] = actividad;
    }
  }

  void actualizarReunion(int index, Reunion reunion) {
    if (index >= 0 && index < reuniones.length) {
      reuniones[index] = reunion;
    }
  }

  void actualizarAcuerdo(int index, Acuerdo acuerdo) {
    if (index >= 0 && index < acuerdos.length) {
      acuerdos[index] = acuerdo;
    }
  }

  // Métodos para eliminar
  void eliminarActividad(int index) {
    if (index >= 0 && index < actividades.length) {
      actividades.removeAt(index);
    }
  }

  void eliminarReunion(int index) {
    if (index >= 0 && index < reuniones.length) {
      reuniones.removeAt(index);
    }
  }

  void eliminarAcuerdo(int index) {
    if (index >= 0 && index < acuerdos.length) {
      acuerdos.removeAt(index);
    }
  }

  // Métodos para gestionar usuarios
  Future<void> addUsuarios(String nombreCompleto, String email, String telefono,
      String ubicacion, String cedula) async {
    await db.collection('usuarios').add({
      "nombreCompleto": nombreCompleto,
      "email": email,
      "telefono": telefono,
      "ubicacion": ubicacion,
      "cedula": cedula
    });
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    List<Map<String, dynamic>> usuarios = [];
    CollectionReference collectionReferenceUsuarios = db.collection('usuarios');

    QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();

    // Guardar datos de los usuarios en la lista
    for (var documento in queryUsuarios.docs) {
      usuarios.add(documento.data() as Map<String, dynamic>);
    }

    return usuarios;
  }
}
