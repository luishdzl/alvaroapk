import 'package:flutter/material.dart';
import '../auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool) onLoginResult;

  const LoginScreen({required this.onLoginResult});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular proceso de login
      await Future.delayed(Duration(seconds: 2));

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email == 'admin@admin' && password == 'admin') {
      // Guardar el estado de sesión
      await AuthService.setLoggedIn(true);
      widget.onLoginResult(true);
      } else {
        widget.onLoginResult(false);
        _showErrorDialog('Credenciales incorrectas');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error de Login'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/alcaldia.jpg'), // Asegúrate de tener esta imagen en tu carpeta assets
            fit: BoxFit.cover, // Cubre toda la pantalla
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white.withOpacity(0.9), // Fondo semi-transparente para mejor legibilidad
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        height: 100,
                        image: AssetImage('assets/logo.png'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 16, 
                          color: const Color.fromARGB(255, 9, 94, 221),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su correo';
                          }
                          if (!value.contains('@')) {
                            return 'Ingrese un correo válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          if (value.length < 3) {
                            return 'La contraseña debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.blue[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Iniciar Sesión', 
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 16),
                      Text(
                        'Credenciales: admin@admin / admin',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}