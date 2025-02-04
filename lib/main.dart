import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/contatos/listar-contatos.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/mapa.dart';
import 'package:flutter_application_1/screens/registro.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // carregando as variáveis de ambiente
  final apiKey = dotenv.env['API_KEY']!;
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: apiKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Final',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CadastroScreen(),

      // definindo as rotas do app
      routes: {
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/home': (context) => const HomePage(),
        "/mapa": (context) => const MapaScreen(),
        "/lista-contatos": (context) => const ListaContatosScreen(),
      },
    );
  }
}
