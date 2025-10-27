import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;
  final Function(String) onMenuSelected;
  final VoidCallback onLogout;

  const TopMenu({
    required this.currentRoute,
    required this.onMenuSelected,
    required this.onLogout,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 768;
    
    return AppBar(
      title: GestureDetector(
        onTap: () => onMenuSelected('/dashboard'),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            'Sistema Comunitario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue[700]!.withOpacity(0.8),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700.withOpacity(0.9),
              Colors.blue.shade700.withOpacity(0.9),
            ],
          ),
        ),
      ),
      actions: [
        if (isLargeScreen) ..._buildDesktopMenu(),
        if (!isLargeScreen) _buildMobileMenu(),
        _buildUserMenu(),
      ],
    );
  }

  List<Widget> _buildDesktopMenu() {
    return [
      _buildMenuButton('Inicio', '/dashboard', Icons.dashboard),
      _buildMenuButton('Proyectos', '/proyectos', Icons.assignment),
      _buildMenuButton('Visitas', '/visitas', Icons.visibility),
      _buildMenuButton('Voceros', '/voceros', Icons.people),
      _buildMenuButton('Asignaciones', '/asignaciones', Icons.assignment_turned_in),
      _buildMenuButton('Evaluaciones', '/evaluaciones', Icons.assessment),
    ];
  }

  Widget _buildMobileMenu() {
    return PopupMenuButton<String>(
      onSelected: onMenuSelected,
      icon: Icon(Icons.menu, color: Colors.white),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(value: '/dashboard', child: ListTile(leading: Icon(Icons.dashboard), title: Text('Inicio'))),
        PopupMenuItem(value: '/proyectos', child: ListTile(leading: Icon(Icons.assignment), title: Text('Proyectos'))),
        PopupMenuItem(value: '/visitas', child: ListTile(leading: Icon(Icons.visibility), title: Text('Visitas'))),
        PopupMenuItem(value: '/voceros', child: ListTile(leading: Icon(Icons.people), title: Text('Voceros'))),
        PopupMenuItem(value: '/asignaciones', child: ListTile(leading: Icon(Icons.assignment_turned_in), title: Text('Asignaciones'))),
        PopupMenuItem(value: '/evaluaciones', child: ListTile(leading: Icon(Icons.assessment), title: Text('Evaluaciones'))),
      ],
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          onLogout();
        }
      },
      icon: Icon(Icons.person, color: Colors.white),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(value: 'profile', child: ListTile(leading: Icon(Icons.person), title: Text('Perfil'))),
        PopupMenuItem(value: 'settings', child: ListTile(leading: Icon(Icons.settings), title: Text('Configuración'))),
        PopupMenuItem(value: 'logout', child: ListTile(leading: Icon(Icons.logout), title: Text('Cerrar Sesión'))),
      ],
    );
  }

  Widget _buildMenuButton(String title, String route, IconData icon) {
    final isSelected = currentRoute == route;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => onMenuSelected(route),
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.white70,
          backgroundColor: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            SizedBox(width: 4),
            Text(title, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}