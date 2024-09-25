import 'package:flutter/material.dart';
import 'package:startenic1/Modelo/modelo_usuario_perfil.dart';
import 'package:startenic1/Vista/vista_ia.dart';

import 'vista_panel.dart'; // Asegúrate de que esta ruta sea correcta

class VistaUsuarioPerfil extends StatefulWidget {
  final UsuarioPerfil usuarioPerfil;

  const VistaUsuarioPerfil({super.key, required this.usuarioPerfil});

  @override
  _VistaUsuarioPerfilState createState() => _VistaUsuarioPerfilState();
}

class _VistaUsuarioPerfilState extends State<VistaUsuarioPerfil> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil de Usuario"),
        backgroundColor: const Color.fromARGB(255, 178, 245, 137),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isEditing
                      ? 'Edición de perfil habilitada'
                      : 'Edición de perfil deshabilitada'),
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(), // Cambiado para usar un método
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de fondo y avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 120, 200, 255),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1725656470843-02e3611ff3f2?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1726053468131-01f99f61715d?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D.jpg"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Text(
              widget.usuarioPerfil.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            // Campos del perfil
            Row(
              children: [
                const Icon(Icons.business,
                    color: Color.fromARGB(255, 243, 167, 25)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: widget.usuarioPerfil.empresa),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Empresa',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.blue),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: widget.usuarioPerfil.tipoDeUsuario,
                    items: <String>['Exportador', 'Importador']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _isEditing ? (String? newValue) {} : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tipo de Usuario',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: widget.usuarioPerfil.ubicacion),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ubicación',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(
                  text: widget.usuarioPerfil.descripcionProducto),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción del producto o servicio',
              ),
              maxLines: 3,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isEditing
                  ? () {
                      // Aquí puedes agregar la lógica para guardar el perfil
                    }
                  : null,
              child: const Text("Guardar Perfil"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 171, 245, 128),
            ),
            child: Center(
              child: Text(
                'StartENic',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 2, 1),
                  fontSize: 50,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VistaUsuarioPerfil(usuarioPerfil: widget.usuarioPerfil),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_agenda),
            title: const Text('Panel de Actividad'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VistaPanel(
                      usuarioPerfil:
                          widget.usuarioPerfil), // Agrega el usuarioPerfil aquí
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('IA StartENic'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
