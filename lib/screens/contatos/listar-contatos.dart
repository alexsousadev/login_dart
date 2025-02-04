import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controller/contatos.controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaContatosScreen extends StatefulWidget {
  const ListaContatosScreen({super.key});

  @override
  ListaContatosScreenState createState() => ListaContatosScreenState();
}

class ListaContatosScreenState extends State<ListaContatosScreen> {

  // trazendo a lista de contatos
  List<dynamic> contatos = [];
  bool isLoading = true;
  final ContatosController contatosController =
      ContatosController(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    listarContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contatos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      for (int i = 0; i < contatos.length; i++)
                        ContatoWidget(
                          nome: contatos[i]['nome_contato'] ??
                              'Nome não disponível',
                          descricao: contatos[i]['contato_descricao'] ??
                              'Descrição não disponível',
                          onDelete: () => {
                            _excluirContato(
                                contatos[i]['id_contato'].toString())
                          },
                          onEdit: () => _editarContato(
                              contatos[i]['id_contato'].toString() ?? ''),
                        ),
                    ],
                  ),
            ElevatedButton(
              onPressed: () {
                // Implementar navegação para tela de cadastro
                print('Cadastrar novo contato');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text(
                'Cadastrar Contato',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarContato(String id) {
    // Implementar navegação para tela de edição
    print('Editar contato ID: $id');
  }

  Future<void> _excluirContato(String id) async {
    try {
      await contatosController.excluirContato(id);
      listarContatos();
      print("Apagou o contato");
    } catch (e) {
      print("Erro ao excluir contato: $e");
    }
  }

  void listarContatos() async {
    try {
      final listaContatos = await contatosController.listarContatos();
      setState(() {
        contatos = listaContatos;
        isLoading = false;
      });

      print("lista de contatos: $listaContatos");
    } catch (e) {
      print("Erro ao listar contatos: $e");
      setState(() => isLoading = false);
    }
  }
}

class ContatoWidget extends StatelessWidget {
  final String nome;
  final String descricao;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ContatoWidget({
    super.key,
    required this.nome,
    required this.descricao,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(
        nome,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(descricao),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
