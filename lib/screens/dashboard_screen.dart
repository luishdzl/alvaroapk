import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Function(String) onMenuSelected;

  const DashboardScreen({required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 4 : screenWidth > 800 ? 3 : 2;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
            Colors.pink.shade50,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final items = [
                      _DashboardItem(
                        title: 'Proyectos',
                        icon: Icons.assignment,
                        color: Colors.blue,
                        route: '/proyectos',
                      ),
                      _DashboardItem(
                        title: 'Visitas',
                        icon: Icons.visibility,
                        color: Colors.green,
                        route: '/visitas',
                      ),
                      _DashboardItem(
                        title: 'Voceros',
                        icon: Icons.people,
                        color: Colors.orange,
                        route: '/voceros',
                      ),
                      _DashboardItem(
                        title: 'Asignaciones',
                        icon: Icons.assignment_turned_in,
                        color: Colors.purple,
                        route: '/asignaciones',
                      ),
                      _DashboardItem(
                        title: 'Evaluaciones',
                        icon: Icons.assessment,
                        color: Colors.teal,
                        route: '/evaluaciones',
                      ),
                      _DashboardItem(
                        title: 'Reportes',
                        icon: Icons.bar_chart,
                        color: Colors.red,
                        route: '/dashboard',
                      ),
                    ];

                    final item = items[index];
                    return _GlassCard(
                      title: item.title,
                      icon: item.icon,
                      color: item.color,
                      onTap: () {
                        if (item.route != '/dashboard') {
                          onMenuSelected(item.route);
                        }
                      },
                    );
                  },
                  childCount: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _GlassCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GlassCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Efecto de desenfoque
              BackdropFilter(
                filter: ColorFilter.mode(
                  Colors.white.withOpacity(0.2),
                  BlendMode.dstATop,
                ),
                child: Container(),
              ),
              // Contenido - CENTRADO
              Container(
                width: double.infinity, // Ocupa todo el ancho disponible
                height: double.infinity, // Ocupa todo el alto disponible
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
                  crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
                  children: [
                    // Icono centrado
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Texto centrado que ocupa todo el ancho disponible
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity, // Ocupa todo el ancho disponible
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black45,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center, // Centra el texto
                          maxLines: 2, // Permite máximo 2 líneas
                          overflow: TextOverflow.ellipsis, // Puntos suspensivos si es muy largo
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Efecto de brillo al hacer hover/tap
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onTap,
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}