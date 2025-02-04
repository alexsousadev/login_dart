import 'package:supabase_flutter/supabase_flutter.dart';

class ContatosController {
  final SupabaseClient supabase;

  ContatosController(this.supabase);

  // Método para listar contatos
  Future<List<Map<String, dynamic>>> listarContatos() async {
    try {
      final response = await supabase.from('contatos').select();
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Erro ao buscar contatos: $e');
    }
  }

  // Método para excluir contato
  Future<void> excluirContato(dynamic id) async {
    final idNumber = (id is int) ? id : int.parse(id);
    await supabase.from('contatos').delete().match({'id_contato': idNumber});
  }
}
