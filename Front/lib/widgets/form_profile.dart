import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/preferences.dart';

class FormProfile extends StatefulWidget {
  const FormProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormProfileState createState() => _FormProfileState();
}

class _FormProfileState extends State<FormProfile> {
  late Future<String> _telefonoFuture;
  late Future<String> _emailFuture;
  late Future<String> _apellidoFuture;
  late Future<String> _nombreFuture;

  @override
  void initState() {
    super.initState();
    _telefonoFuture = Preferences.getTelefono();
    _emailFuture = Preferences.getEmail();
    _apellidoFuture = Preferences.getApellido();
    _nombreFuture = Preferences.getNombre();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_telefonoFuture, _emailFuture, _apellidoFuture, _nombreFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final telefono = snapshot.data![0];
        final email = snapshot.data![1];
        final apellido = snapshot.data![2];
        final nombre = snapshot.data![3];

        return Column(
          children: [
            TextFormField(
              initialValue: telefono,
              onChanged: (value) {
                Preferences.setTelefono(value);
              },
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                icon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: email,
              onChanged: (value) {
                Preferences.setEmail(value);
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.alternate_email_outlined),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: apellido,
              onChanged: (value) {
                Preferences.setApellido(value);
              },
              decoration: const InputDecoration(
                labelText: 'Apellido',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: nombre,
              onChanged: (value) {
                Preferences.setNombre(value);
              },
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
          ],
        );
      },
    );
  }
}
