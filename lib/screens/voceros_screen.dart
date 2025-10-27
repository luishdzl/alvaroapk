import 'package:flutter/material.dart';
import '../models/vocero.dart';
import '../services/data_service.dart';
import '../widgets/search_widget.dart';
import './vocero_detail_screen.dart';

class VocerosScreen extends StatefulWidget {
  @override
  _VocerosScreenState createState() => _VocerosScreenState();
}

class _VocerosScreenState extends State<VocerosScreen> {
  late Future<List<Vocero>> futureVoceros;
  List<Vocero> _allVoceros = [];
  List<Vocero> _filteredVoceros = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureVoceros = DataService.loadVoceros().then((voceros) {
      setState(() {
        _allVoceros = voceros;
        _filteredVoceros = voceros;
      });
      return voceros;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredVoceros = _allVoceros;
      } else {
        _filteredVoceros = _allVoceros.where((vocero) {
          return vocero.nombre.toLowerCase().contains(_searchQuery) ||
                 vocero.apellido.toLowerCase().contains(_searchQuery) ||
                 vocero.cedula.toLowerCase().contains(_searchQuery) ||
                 vocero.telefono.toLowerCase().contains(_searchQuery) ||
                 vocero.correo.toLowerCase().contains(_searchQuery) ||
                 vocero.tipoVocero.toLowerCase().contains(_searchQuery) ||
                 vocero.genero.toLowerCase().contains(_searchQuery) ||
                 vocero.direccion.toLowerCase().contains(_searchQuery) ||
                 vocero.edad.toString().contains(_searchQuery) ||
                 vocero.id.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _filteredVoceros = _allVoceros;
    });
  }

  void _navigateToDetail(Vocero vocero) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoceroDetailScreen(vocero: vocero),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voceros'),
        backgroundColor: Colors.orange[700],
      ),
      body: Column(
        children: [
          // Buscador
          SearchWidget(
            hintText: 'Buscar voceros...',
            onSearchChanged: _onSearchChanged,
            onSearchCleared: _onSearchCleared,
          ),
          
          // Contador de resultados
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredVoceros.length} voceros encontrados',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  Flexible(
                    child: Text(
                      'Búsqueda: "$_searchQuery"',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Lista de voceros
          Expanded(
            child: FutureBuilder<List<Vocero>>(
              future: futureVoceros,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredVoceros.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: _filteredVoceros.length,
                  itemBuilder: (context, index) {
                    Vocero vocero = _filteredVoceros[index];
                    return _buildVoceroCard(vocero);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoceroCard(Vocero vocero) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getTypeColor(vocero.tipoVocero).withOpacity(0.2),
            border: Border.all(color: _getTypeColor(vocero.tipoVocero), width: 2),
          ),
          child: Center(
            child: Text(
              '${vocero.nombre[0]}${vocero.apellido[0]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getTypeColor(vocero.tipoVocero),
              ),
            ),
          ),
        ),
        title: Text(
          '${vocero.nombre} ${vocero.apellido}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // Usamos Wrap en lugar de Row para los chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildInfoChip('${vocero.edad} años', Icons.person),
                _buildTypeChip(vocero.tipoVocero, _getTypeColor(vocero.tipoVocero)),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Cédula: ${vocero.cedula}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            SizedBox(height: 4),
            // Información de contacto en columnas para pantallas pequeñas
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 300) {
                  // Para pantallas más anchas: mostrar en fila
                  return Row(
                    children: [
                      Expanded(
                        child: _buildContactInfo(
                          Icons.phone,
                          vocero.telefono,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildContactInfo(
                          Icons.email,
                          vocero.correo,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Para pantallas más estrechas: mostrar en columna
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactInfo(Icons.phone, vocero.telefono),
                      SizedBox(height: 4),
                      _buildContactInfo(Icons.email, vocero.correo),
                    ],
                  );
                }
              },
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange[700]),
        ),
        onTap: () => _navigateToDetail(vocero),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.blue[700]),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String tipo, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.badge, size: 12, color: color),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              tipo,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No hay voceros' : 'No se encontraron resultados',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          if (_searchQuery.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Intenta con otros términos de búsqueda',
              style: TextStyle(color: Colors.grey[500]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onSearchCleared,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
              ),
              child: Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTypeColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'principal':
        return Colors.orange;
      case 'suplente':
        return Colors.blue;
      case 'comunitario':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}