import 'package:flutter/material.dart';
import '../models/visita.dart';
import '../services/data_service.dart';
import '../widgets/search_widget.dart';
import './visita_detail_screen.dart';

class VisitasScreen extends StatefulWidget {
  @override
  _VisitasScreenState createState() => _VisitasScreenState();
}

class _VisitasScreenState extends State<VisitasScreen> {
  late Future<List<Visita>> futureVisitas;
  List<Visita> _allVisitas = [];
  List<Visita> _filteredVisitas = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureVisitas = DataService.loadVisitas().then((visitas) {
      setState(() {
        _allVisitas = visitas;
        _filteredVisitas = visitas;
      });
      return visitas;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredVisitas = _allVisitas;
      } else {
        _filteredVisitas = _allVisitas.where((visita) {
          return visita.visita.toLowerCase().contains(_searchQuery) ||
                 visita.descripcionVis.toLowerCase().contains(_searchQuery) ||
                 visita.idParroquia.toString().contains(_searchQuery) ||
                 visita.idComunidad.toString().contains(_searchQuery) ||
                 visita.id.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _filteredVisitas = _allVisitas;
    });
  }

  void _navigateToDetail(Visita visita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitaDetailScreen(visita: visita),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitas'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // Buscador
          SearchWidget(
            hintText: 'Buscar visitas...',
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
                  '${_filteredVisitas.length} visitas encontradas',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    'Búsqueda: "$_searchQuery"',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Lista de visitas
          Expanded(
            child: FutureBuilder<List<Visita>>(
              future: futureVisitas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredVisitas.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: _filteredVisitas.length,
                  itemBuilder: (context, index) {
                    Visita visita = _filteredVisitas[index];
                    return _buildVisitaCard(visita);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitaCard(Visita visita) {
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
            color: _getTypeColor(visita.visita).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.visibility, color: _getTypeColor(visita.visita)),
        ),
        title: Text(
          visita.visita,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              visita.descripcionVis,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildLocationChip('Parroquia ${visita.idParroquia}', Icons.location_on),
                SizedBox(width: 8),
                _buildLocationChip('Comunidad ${visita.idComunidad}', Icons.people),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category, size: 12, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  _getVisitType(visita.visita),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green[700]),
        ),
        onTap: () => _navigateToDetail(visita),
      ),
    );
  }

  Widget _buildLocationChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.green[700]),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[700]),
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
            _searchQuery.isEmpty ? 'No hay visitas' : 'No se encontraron resultados',
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
                backgroundColor: Colors.green[700],
              ),
              child: Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTypeColor(String tipoVisita) {
    if (tipoVisita.toLowerCase().contains('inspección')) {
      return Colors.orange;
    } else if (tipoVisita.toLowerCase().contains('seguimiento')) {
      return Colors.blue;
    } else if (tipoVisita.toLowerCase().contains('evaluación')) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  String _getVisitType(String visita) {
    if (visita.toLowerCase().contains('inspección')) {
      return 'Inspección';
    } else if (visita.toLowerCase().contains('seguimiento')) {
      return 'Seguimiento';
    } else if (visita.toLowerCase().contains('evaluación')) {
      return 'Evaluación';
    } else {
      return 'Visita General';
    }
  }
}