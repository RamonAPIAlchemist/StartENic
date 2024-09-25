import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:startenic1/Controlador/controlador_usuario_perfil.dart';
import 'package:startenic1/Modelo/modelo_usuario_perfil.dart';

class VistaBusquedaPerfil extends StatefulWidget {
  const VistaBusquedaPerfil({super.key});

  @override
  _VistaBusquedaPerfilState createState() => _VistaBusquedaPerfilState();
}

class _VistaBusquedaPerfilState extends State<VistaBusquedaPerfil> {
  final ControladorUsuarioPerfil _controlador = ControladorUsuarioPerfil();
  final TextEditingController _searchController = TextEditingController();
  String _selectedSector = '';
  String _selectedUbicacion = '';
  String _selectedTipoUsuario = '';

  List<UsuarioPerfil> _resultadosBusqueda = [];
  bool _isLoading = false; // Para mostrar un indicador de carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Perfiles por Sector Productivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Usuario o Empresa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSector.isEmpty ? null : _selectedSector,
              onChanged: (value) {
                setState(() {
                  _selectedSector = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Seleccionar Sector Productivo',
                border: OutlineInputBorder(),
              ),
              items: [
                'Agricultura',
                'Tecnología',
                'Manufactura',
                'Educación',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedUbicacion = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedTipoUsuario.isEmpty ? null : _selectedTipoUsuario,
              onChanged: (value) {
                setState(() {
                  _selectedTipoUsuario = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de Usuario',
                border: OutlineInputBorder(),
              ),
              items: [
                'Proveedor',
                'Exportador',
                'Distribuidor',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarPerfiles,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _resultadosBusqueda.isEmpty
                    ? const Text('No se encontraron resultados.')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _resultadosBusqueda.length,
                          itemBuilder: (context, index) {
                            final perfil = _resultadosBusqueda[index];
                            return Card(
                              child: ListTile(
                                title: Text(perfil.name),
                                subtitle: Text('Empresa: ${perfil.empresa}\n'
                                    'Ubicación: ${perfil.ubicacion}\n'
                                    'Tipo de Usuario: ${perfil.tipoDeUsuario}'),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  void _buscarPerfiles() async {
    String queryNombre = _searchController.text.trim();
    String querySector = _selectedSector;
    String queryUbicacion = _selectedUbicacion;
    String queryTipoUsuario = _selectedTipoUsuario;

    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      Query query = _controlador.db.collection('usuarios');

      // Filtro por nombre
      if (queryNombre.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: queryNombre)
            .where('name', isLessThanOrEqualTo: '$queryNombre\uf8ff');
      }

      // Filtro por sector productivo
      if (querySector.isNotEmpty) {
        query = query.where('tipoDeUsuario', isEqualTo: querySector);
      }

      // Filtro por ubicación
      if (queryUbicacion.isNotEmpty) {
        query = query.where('ubicacion', isEqualTo: queryUbicacion);
      }

      // Filtro por tipo de usuario
      if (queryTipoUsuario.isNotEmpty) {
        query = query.where('tipoDeUsuario', isEqualTo: queryTipoUsuario);
      }

      QuerySnapshot result = await query.get();

      List<UsuarioPerfil> perfiles = result.docs.map((doc) {
        return UsuarioPerfil(
          name: doc['name'],
          email: doc['email'],
          empresa: doc['empresa'],
          tipoDeUsuario: doc['tipoDeUsuario'],
          ubicacion: doc['ubicacion'],
          descripcionProducto: doc['descripcionProducto'],
        );
      }).toList();

      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _resultadosBusqueda = perfiles;
          _isLoading = false; // Ocultar indicador de carga
        });
      }
    } catch (e) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la búsqueda: $e')),
        );
      }
    }
  }
}
