import 'package:flutter/material.dart';
import 'package:flutter_app/themes/default_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _temaActual;

  ThemeProvider({required bool isDarkMode})
      : _temaActual = isDarkMode ? DefaultTheme.darkTheme : DefaultTheme.lightTheme;

  ThemeData get temaActual => _temaActual;

  // Cambiar a tema claro
  void setLight() {
    _temaActual = DefaultTheme.lightTheme;
    notifyListeners();
  }

  // Cambiar a tema oscuro
  void setDark() {
    _temaActual = DefaultTheme.darkTheme;
    notifyListeners();
  }

  // Alternar entre los dos temas
  void toggleTheme() {
    if (_temaActual == DefaultTheme.darkTheme) {
      setLight();
    } else {
      setDark();
    }
  }
}