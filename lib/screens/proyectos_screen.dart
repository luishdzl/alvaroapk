import 'package:flutter/material.dart';
import '../models/proyecto.dart';
import '../services/data_service.dart';
import '../widgets/search_widget.dart';
import './proyecto_detail_screen.dart';

class ProyectosScreen extends StatefulWidget {
  @override
  _ProyectosScreenState createState() => _ProyectosScreenState();
}

class _ProyectosScreenState extends State<ProyectosScreen> {
  late Future<List<Proyecto>> futureProyectos;
  List<Proyecto> _allProyectos = [];
  List<Proyecto> _filteredProyectos = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureProyectos = DataService.loadProyectos().then((proyectos) {
      setState(() {
        _allProyectos = proyectos;
        _filteredProyectos = proyectos;
      });
      return proyectos;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredProyectos = _allProyectos;
      } else {
        _filteredProyectos = _allProyectos.where((proyecto) {
          return proyecto.nombrePro.toLowerCase().contains(_searchQuery) ||
                 proyecto.descripcionPro.toLowerCase().contains(_searchQuery) ||
                 proyecto.tipoPro.toLowerCase().contains(_searchQuery) ||
                 proyecto.prioridad.toLowerCase().contains(_searchQuery) ||
                 proyecto.actividades.toLowerCase().contains(_searchQuery) ||
                 proyecto.actaConformidad.toLowerCase().contains(_searchQuery) ||
                 proyecto.fechaInicial.toLowerCase().contains(_searchQuery) ||
                 proyecto.fechaFinal.toLowerCase().contains(_searchQuery) ||
                 proyecto.id.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _filteredProyectos = _allProyectos;
    });
  }

  void _navigateToDetail(Proyecto proyecto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProyectoDetailScreen(proyecto: proyecto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos'),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // Buscador
          SearchWidget(
            hintText: 'Buscar proyectos...',
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
                  '${_filteredProyectos.length} proyectos encontrados',
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
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Lista de proyectos
          Expanded(
            child: FutureBuilder<List<Proyecto>>(
              future: futureProyectos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredProyectos.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: _filteredProyectos.length,
                  itemBuilder: (context, index) {
                    Proyecto proyecto = _filteredProyectos[index];
                    return _buildProyectoCard(proyecto);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProyectoCard(Proyecto proyecto) {
    final status = _getProjectStatus(proyecto);
    final statusColor = _getStatusColor(status);
    
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
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.assignment, color: Colors.blue[700]),
        ),
        title: Text(
          proyecto.nombrePro,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              proyecto.descripcionPro,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            // Usamos Wrap en lugar de Row para los chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildPriorityChip(proyecto.prioridad, _getPriorityColor(proyecto.prioridad)),
                _buildStatusChip(status, statusColor),
              ],
            ),
            SizedBox(height: 4),
            // Información de fechas y tipo en diseño responsive
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 350) {
                  // Para pantallas más anchas: mostrar en fila
                  return Row(
                    children: [
                      Expanded(
                        child: _buildDateInfo(
                          Icons.calendar_today,
                          '${_formatDate(proyecto.fechaInicial)} - ${_formatDate(proyecto.fechaFinal)}',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildTypeInfo(
                          Icons.category,
                          proyecto.tipoPro,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Para pantallas más estrechas: mostrar en columna
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateInfo(
                        Icons.calendar_today,
                        '${_formatDate(proyecto.fechaInicial)} - ${_formatDate(proyecto.fechaFinal)}',
                      ),
                      SizedBox(height: 4),
                      _buildTypeInfo(
                        Icons.category,
                        proyecto.tipoPro,
                      ),
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
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[700]),
        ),
        onTap: () => _navigateToDetail(proyecto),
      ),
    );
  }

  Widget _buildDateInfo(IconData icon, String text) {
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

  Widget _buildTypeInfo(IconData icon, String text) {
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

  Widget _buildPriorityChip(String prioridad, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 12, color: color),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              prioridad,
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
          Flexible(
            child: Text(
              status,
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
            _searchQuery.isEmpty ? 'No hay proyectos' : 'No se encontraron resultados',
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
                backgroundColor: Colors.blue[700],
              ),
              child: Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPriorityColor(String prioridad) {
    switch (prioridad.toLowerCase()) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'completado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return Icons.play_arrow;
      case 'pendiente':
        return Icons.schedule;
      case 'completado':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  String _getProjectStatus(Proyecto proyecto) {
    final now = DateTime.now();
    final start = DateTime.parse(proyecto.fechaInicial);
    final end = DateTime.parse(proyecto.fechaFinal);

    if (now.isBefore(start)) return 'Pendiente';
    if (now.isAfter(end)) return 'Completado';
    return 'Activo';
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