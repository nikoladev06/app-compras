import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:proj_compras/view/inicio_view.dart';
import 'package:proj_compras/view/cadastrar_view.dart';
import 'package:proj_compras/view/login_view.dart';
import 'package:proj_compras/view/recuperarsenha_view.dart';
import 'package:proj_compras/view/sobre_view.dart';
import 'package:proj_compras/view/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MainApp(),
      )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navegação',
      initialRoute: 'inicio',
      routes: {
        'inicio': (context) => InicioView(),
        'cadastrar': (context) => CadastrarView(),
        'login': (context) => LoginView(),
        'recuperar' : (context) => RecuperarsenhaView(),
        'principal' : (context) => const HomeView(),
        'sobre' : (context) => const SobreView(),
      }
    );
  }
}