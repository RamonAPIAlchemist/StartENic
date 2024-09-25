class Actividad {
  String descripcion;
  DateTime fecha;
  bool completada;

  Actividad({
    required this.descripcion,
    required this.fecha,
    this.completada = false,
  });

  // Método para marcar la actividad como completada
  void marcarComoCompletada() {
    completada = true;
  }
}

class Reunion {
  String titulo;
  DateTime fecha;
  List<String> participantes; // Cambiado a List<String> para una mejor gestión
  bool programada;

  Reunion({
    required this.titulo,
    required this.fecha,
    required List<String> participantes,
    this.programada = true,
  }) : participantes =
            List.from(participantes); // Asegura que se crea una copia

  // Método para agregar un participante
  void agregarParticipante(String participante) {
    participantes.add(participante);
  }
}

class Acuerdo {
  String descripcion;
  bool cerrado;

  Acuerdo({
    required this.descripcion,
    this.cerrado = false,
  });

  // Método para cerrar el acuerdo
  void cerrar() {
    cerrado = true;
  }
}
