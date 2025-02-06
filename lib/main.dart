import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:flutter_application_1/screens/contatos/listar-contatos.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/mapa.dart';
import 'package:flutter_application_1/screens/registro.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await loadEnvVariables(); // Ensure this function loads your environment variables

  final keysEnv = EnvVariables();

  // Verificando se as variáveis de ambiente estão definidas
  if (keysEnv.supabaseUrl.isEmpty || keysEnv.apiKey.isEmpty) {
    throw Exception(
        "As variáveis de ambiente não estão definidas corretamente.");
  }

  print(keysEnv);

  await Supabase.initialize(
    url: keysEnv.supabaseUrl,
    anonKey: keysEnv.apiKey,
  );

  runApp(const MyApp());
}

// Function to load environment variables
Future<void> loadEnvVariables() async {
  // Implement the logic to load your environment variables here
  // For example, using dotenv package:
  await dotenv.load(fileName: ".env");
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
