import 'package:flutter/material.dart';
import '../models/asignacion.dart';
import '../services/data_service.dart';
import '../widgets/search_widget.dart';
import './asignacion_detail_screen.dart';

class AsignacionesScreen extends StatefulWidget {
  @override
  _AsignacionesScreenState createState() => _AsignacionesScreenState();
}

class _AsignacionesScreenState extends State<AsignacionesScreen> {
  late Future<List<Asignacion>> futureAsignaciones;
  List<Asignacion> _allAsignaciones = [];
  List<Asignacion> _filteredAsignaciones = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureAsignaciones = DataService.loadAsignaciones().then((asignaciones) {
      setState(() {
        _allAsignaciones = asignaciones;
        _filteredAsignaciones = asignaciones;
      });
      return asignaciones;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredAsignaciones = _allAsignaciones;
      } else {
        _filteredAsignaciones = _allAsignaciones.where((asignacion) {
          return asignacion.descriAlcance.toLowerCase().contains(_searchQuery) ||
                 asignacion.direccion.toLowerCase().contains(_searchQuery) ||
                 asignacion.monedaPresu.toLowerCase().contains(_searchQuery) ||
                 asignacion.duracionEstimada.toLowerCase().contains(_searchQuery) ||
                 asignacion.presupuesto.toString().contains(_searchQuery) ||
                 asignacion.id.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _filteredAsignaciones = _allAsignaciones;
    });
  }

  void _navigateToDetail(Asignacion asignacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsignacionDetailScreen(asignacion: asignacion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asignaciones'),
        backgroundColor: Colors.purple[700],
      ),
      body: Column(
        children: [
          // Buscador
          SearchWidget(
            hintText: 'Buscar asignaciones...',
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
                  '${_filteredAsignaciones.length} asignaciones encontradas',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    'Búsqueda: "$_searchQuery"',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Lista de asignaciones
          Expanded(
            child: FutureBuilder<List<Asignacion>>(
              future: futureAsignaciones,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredAsignaciones.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: _filteredAsignaciones.length,
                  itemBuilder: (context, index) {
                    Asignacion asignacion = _filteredAsignaciones[index];
                    return _buildAsignacionCard(asignacion);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsignacionCard(Asignacion asignacion) {
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
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.assignment_turned_in, color: Colors.purple[700]),
        ),
        title: Text(
          'Asignación #${asignacion.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              asignacion.descriAlcance,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip('${asignacion.monedaPresu} ${asignacion.presupuesto.toStringAsFixed(0)}', Icons.attach_money),
                SizedBox(width: 8),
                _buildInfoChip(asignacion.duracionEstimada, Icons.schedule),
              ],
            ),
            SizedBox(height: 4),
            Text(
              asignacion.direccion,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.purple[700]),
        ),
        onTap: () => _navigateToDetail(asignacion),
      ),
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
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue[700]),
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
            _searchQuery.isEmpty ? 'No hay asignaciones' : 'No se encontraron resultados',
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
              child: Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }
}