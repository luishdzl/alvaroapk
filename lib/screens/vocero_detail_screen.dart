import 'package:flutter/material.dart';
import '../models/vocero.dart';

class VoceroDetailScreen extends StatelessWidget {
  final Vocero vocero;

  const VoceroDetailScreen({Key? key, required this.vocero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Vocero'),
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.deepOrange.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con avatar e información básica
              _buildHeaderCard(),

              // Información Personal
              _buildSectionTitle('Información Personal'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Cédula', vocero.cedula),
                  _buildDetailItem('Fecha de Nacimiento', _formatDate(vocero.fechaNacimiento)),
                  _buildDetailItem('Edad', '${vocero.edad} años'),
                  _buildDetailItem('Género', vocero.genero),
                ],
              ),

              // Información de Contacto - MEJORADO PARA MÓVILES
              _buildSectionTitle('Información de Contacto'),
              _buildDetailCard(
                children: [
                  _buildContactItem('Teléfono', vocero.telefono, Icons.phone),
                  _buildContactItem('Correo', vocero.correo, Icons.email),
                  _buildContactItem('Dirección', vocero.direccion, Icons.location_on),
                ],
              ),

              // Información del Cargo
              _buildSectionTitle('Información del Cargo'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Tipo de Vocero', vocero.tipoVocero, isType: true),
                  _buildDetailItem('ID Cargo', vocero.idCargo.toString()),
                ],
              ),

              // Resumen del Vocero
              _buildSectionTitle('Resumen'),
              _buildDetailCard(
                children: [
                  _buildVoceroSummary(),
                ],
              ),

              // Botones de acción
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text('Volver', style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(0.2),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Center(
                child: Text(
                  '${vocero.nombre[0]}${vocero.apellido[0]}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Información básica
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vocero.nombre} ${vocero.apellido}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(vocero.tipoVocero),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      vocero.tipoVocero,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Cédula: ${vocero.cedula}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange[800],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isType = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isType
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(value),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Para pantallas pequeñas (menos de 400px de ancho), usar diseño vertical
          if (constraints.maxWidth < 400) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 16, color: Colors.orange[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          // SIN puntos suspensivos - texto completo visible
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Para pantallas más grandes, usar diseño horizontal
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '$label:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 16, color: Colors.orange[700]),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            // SIN puntos suspensivos - texto completo visible
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildVoceroSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Tipo', vocero.tipoVocero, _getTypeColor(vocero.tipoVocero)),
        _buildSummaryItem('Edad', '${vocero.edad}', Colors.blue),
        _buildSummaryItem('Género', vocero.genero, Colors.purple),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            value.length > 1 ? value.substring(0, 1) : value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}