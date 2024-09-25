import 'package:flutter/material.dart';
import 'package:startenic1/Controlador/controlador_panel.dart';
import 'package:startenic1/Modelo/modelo_panel.dart';
import 'package:startenic1/Modelo/modelo_usuario_perfil.dart';
import 'package:startenic1/Vista/vista_usuario_perfil.dart'; // Asegúrate de importar la vista correcta

class VistaPanel extends StatefulWidget {
  final UsuarioPerfil usuarioPerfil; // Agregando el perfil de usuario

  const VistaPanel(
      {super.key, required this.usuarioPerfil}); // Modificando el constructor

  @override
  State<VistaPanel> createState() => _VistaPanelState();
}

class _VistaPanelState extends State<VistaPanel> {
  final DashboardControlador controller = DashboardControlador();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Control para Actividades'),
        backgroundColor: const Color.fromARGB(
            255, 146, 240, 149), // Cambia el color del AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VistaUsuarioPerfil(usuarioPerfil: widget.usuarioPerfil),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSection('Actividades Diarias',
              controller.actividades.map(_buildActividadItem).toList()),
          _buildSection('Reuniones Programadas',
              controller.reuniones.map(_buildReunionItem).toList()),
          _buildSection('Acuerdos Cerrados',
              controller.acuerdos.map(_buildAcuerdoItem).toList()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(10),
        color: const Color.fromARGB(
            255, 199, 241, 149), // Color de fondo de la tarjeta
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centrar los elementos
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center, // Centrar el texto
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(children: items),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActividadItem(Actividad actividad) {
    return ListTile(
      title: Text(
        actividad.descripcion,
        style: TextStyle(
          color: actividad.completada
              ? Colors.green
              : Colors.red, // Color del título
        ),
      ),
      subtitle: Text(
        'Fecha: ${actividad.fecha.toString()}',
        style: TextStyle(
          color: Colors.grey[600], // Color del subtítulo
        ),
      ),
      trailing: Icon(
        actividad.completada ? Icons.check_circle : Icons.circle_outlined,
        color:
            actividad.completada ? Colors.green : Colors.red, // Color del ícono
      ),
    );
  }

  Widget _buildReunionItem(Reunion reunion) {
    return ListTile(
      title: Text(
        reunion.titulo,
        style: const TextStyle(
          color: Colors.blueAccent, // Color del título
        ),
      ),
      subtitle: Text(
        'Participantes: ${reunion.participantes}\nFecha: ${reunion.fecha}',
        style: TextStyle(
          color: Colors.grey[600], // Color del subtítulo
        ),
      ),
      trailing: Icon(
        reunion.programada ? Icons.event : Icons.event_available,
        color:
            reunion.programada ? Colors.blue : Colors.grey, // Color del ícono
      ),
    );
  }

  Widget _buildAcuerdoItem(Acuerdo acuerdo) {
    return ListTile(
      title: Text(
        acuerdo.descripcion,
        style: TextStyle(
          color:
              acuerdo.cerrado ? Colors.green : Colors.red, // Color del título
        ),
      ),
      trailing: Icon(
        acuerdo.cerrado ? Icons.check : Icons.close,
        color: acuerdo.cerrado ? Colors.green : Colors.red, // Color del ícono
      ),
    );
  }
}
