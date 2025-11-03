import 'package:flutter/material.dart';
import '../models/planificacion.dart';
import '../services/data_service.dart';
import '../widgets/search_widget.dart';
import './planificacion_detail_screen.dart';

class PlanificacionScreen extends StatefulWidget {
  @override
  _PlanificacionScreenState createState() => _PlanificacionScreenState();
}

class _PlanificacionScreenState extends State<PlanificacionScreen> {
  late Future<List<Planificacion>> futurePlanificacion;
  List<Planificacion> _allPlanificacion = [];
  List<Planificacion> _filteredPlanificacion = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futurePlanificacion = DataService.loadPlanificacion().then((planificacion) {
      setState(() {
        _allPlanificacion = planificacion;
        _filteredPlanificacion = planificacion;
      });
      return planificacion;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredPlanificacion = _allPlanificacion;
      } else {
        _filteredPlanificacion = _allPlanificacion.where((planificacion) {
          return planificacion.descriAlcance.toLowerCase().contains(_searchQuery) ||
                 planificacion.direccion.toLowerCase().contains(_searchQuery) ||
                 planificacion.monedaPresu.toLowerCase().contains(_searchQuery) ||
                 planificacion.duracionEstimada.toLowerCase().contains(_searchQuery) ||
                 planificacion.presupuesto.toString().contains(_searchQuery) ||
                 planificacion.id.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _filteredPlanificacion = _allPlanificacion;
    });
  }

  void _navigateToDetail(Planificacion planificacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanificacionDetailScreen(planificacion: planificacion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planificacion'),
        backgroundColor: Colors.purple[700],
      ),
      body: Column(
        children: [
          // Buscador
          SearchWidget(
            hintText: 'Buscar planificacion...',
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
                  '${_filteredPlanificacion.length} planificacion encontradas',
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
          
          // Lista de planificacion
          Expanded(
            child: FutureBuilder<List<Planificacion>>(
              future: futurePlanificacion,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredPlanificacion.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: _filteredPlanificacion.length,
                  itemBuilder: (context, index) {
                    Planificacion planificacion = _filteredPlanificacion[index];
                    return _buildPlanificacionCard(planificacion);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanificacionCard(Planificacion planificacion) {
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
          'Asignación #${planificacion.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              planificacion.descriAlcance,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip('${planificacion.monedaPresu} ${planificacion.presupuesto.toStringAsFixed(0)}', Icons.attach_money),
                SizedBox(width: 8),
                _buildInfoChip(planificacion.duracionEstimada, Icons.schedule),
              ],
            ),
            SizedBox(height: 4),
            Text(
              planificacion.direccion,
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
        onTap: () => _navigateToDetail(planificacion),
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
            _searchQuery.isEmpty ? 'No hay planificacion' : 'No se encontraron resultados',
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