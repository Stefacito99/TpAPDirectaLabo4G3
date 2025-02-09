import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _themeKey = 'isDarkMode';
  static const _telefonoKey = 'telefono';
  static const _emailKey = 'email';
  static const _apellidoKey = 'apellido';
  static const _nombreKey = 'nombre';

  // Tema
  static Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // false por defecto (modo claro)
  }

  static Future<void> setThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Teléfono
  static Future<String> getTelefono() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_telefonoKey) ?? ''; // Vacío por defecto
  }

  static Future<void> setTelefono(String telefono) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_telefonoKey, telefono);
  }

  // Email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  // Apellido
  static Future<String> getApellido() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apellidoKey) ?? '';
  }

  static Future<void> setApellido(String apellido) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apellidoKey, apellido);
  }

  // Nombre
  static Future<String> getNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nombreKey) ?? '';
  }

  static Future<void> setNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nombreKey, nombre);
  }
}
