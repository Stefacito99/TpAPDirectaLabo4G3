import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene el tema activo desde el ThemeProvider
    final theme = Provider.of<ThemeProvider>(context).temaActual;

    return AppBar(
      title: Text(title),
      centerTitle: true,
      leadingWidth: 40,
      toolbarHeight: 60,
      backgroundColor: theme.appBarTheme.backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
