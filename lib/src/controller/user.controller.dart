import 'package:supabase_flutter/supabase_flutter.dart';

// Método para realizar o cadastro
Future<void> signUp(String email, String password) async {
  try {
    final response = await Supabase.instance.client.auth.signUp(
      email: email.trim(),
      password: password.trim(),
    );

    // Verifique se o cadastro foi bem-sucedido
    if (response.user != null) {
      print('Cadastro realizado com sucesso: ${response.user!.email}');
    } else {
      print('Erro ao realizar o cadastro: $response');
    }
  } catch (e) {
    print('Erro durante o cadastro: $e');
  }
}

// Método para realizar o login
Future<void> signIn(String email, String password) async {
  try {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Verifique se o login foi bem-sucedido
    if (response.user != null) {
      print('Login realizado com sucesso: ${response.user!.email}');
    } else {
      print('Erro ao realizar o login: $response');
    }
  } catch (e) {
    print('Erro durante o login: $e');
  }
}
