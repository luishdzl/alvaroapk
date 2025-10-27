import 'package:flutter/material.dart';
import '../models/evaluacion.dart';
import '../services/data_service.dart';
import '../widgets/search_widget.dart';
import './evaluacion_detail_screen.dart';

class EvaluacionesScreen extends StatefulWidget {
  @override
  _EvaluacionesScreenState createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  late Future<List<Evaluacion>> futureEvaluaciones;
  List<Evaluacion> _allEvaluaciones = [];
  List<Evaluacion> _filteredEvaluaciones = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureEvaluaciones = DataService.loadEvaluaciones().then((evaluaciones) {
      setState(() {
        _allEvaluaciones = evaluaciones;
        _filteredEvaluaciones = evaluaciones;
      });
      return evaluaciones;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredEvaluaciones = _allEvaluaciones;
      } else {
        _filteredEvaluaciones = _allEvaluaciones.where((evaluacion) {
          return evaluacion.estatus.toLowerCase().contains(_searchQuery) ||
                 evaluacion.viabilidad.toLowerCase().contains(_searchQuery) ||
                 evaluacion.observaciones.toLowerCase().contains(_searchQuery) ||
                 evaluacion.fechaEvalu.toLowerCase().contains(_searchQuery) ||
                 evaluacion.estatusResp.toLowerCase().contains(_searchQuery) ||
                 evaluacion.id.toString().contains(_searchQuery) ||
                 evaluacion.idProyecto.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _filteredEvaluaciones = _allEvaluaciones;
    });
  }

  void _navigateToDetail(Evaluacion evaluacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluacionDetailScreen(evaluacion: evaluacion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluaciones'),
        backgroundColor: Colors.teal[700],
      ),
      body: Column(
        children: [
          // Buscador
          SearchWidget(
            hintText: 'Buscar evaluaciones...',
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
                  '${_filteredEvaluaciones.length} evaluaciones encontradas',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    'Búsqueda: "$_searchQuery"',
                    style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Lista de evaluaciones
          Expanded(
            child: FutureBuilder<List<Evaluacion>>(
              future: futureEvaluaciones,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredEvaluaciones.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: _filteredEvaluaciones.length,
                  itemBuilder: (context, index) {
                    Evaluacion evaluacion = _filteredEvaluaciones[index];
                    return _buildEvaluacionCard(evaluacion);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluacionCard(Evaluacion evaluacion) {
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
            color: _getStatusColor(evaluacion.estatus).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getStatusIcon(evaluacion.estatus),
            color: _getStatusColor(evaluacion.estatus),
            size: 30,
          ),
        ),
        title: Text(
          'Evaluación #${evaluacion.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              evaluacion.observaciones,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip(evaluacion.estatus, _getStatusColor(evaluacion.estatus)),
                SizedBox(width: 8),
                _buildViabilidadChip(evaluacion.viabilidad, _getViabilidadColor(evaluacion.viabilidad)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  _formatDate(evaluacion.fechaEvalu),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Spacer(),
                Icon(Icons.fact_check, size: 12, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  'Proyecto #${evaluacion.idProyecto}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal[700]),
        ),
        onTap: () => _navigateToDetail(evaluacion),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), size: 12, color: color),
          SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildViabilidadChip(String viabilidad, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            viabilidad,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
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
            _searchQuery.isEmpty ? 'No hay evaluaciones' : 'No se encontraron resultados',
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
                backgroundColor: Colors.teal[700],
              ),
              child: Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getViabilidadColor(String viabilidad) {
    switch (viabilidad.toLowerCase()) {
      case 'alta':
        return Colors.green;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.pending;
      case 'rechazado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}