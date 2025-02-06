import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrarContatoScreen extends StatelessWidget {
  const RegistrarContatoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController numeroController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();
    final TextEditingController enderecoController = TextEditingController();

    double borderValue = 5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registrar Contato'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'ifpi.png',
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 48),

              // Campo Nome
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Número
              TextField(
                controller: numeroController,
                decoration: InputDecoration(
                  labelText: 'Número',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Descrição
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              // Campo Endereço
              TextField(
                controller: enderecoController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: borderValue, color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Botão Cadastrar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    String nome = nomeController.text.trim();
                    String numero = numeroController.text.trim();
                    String descricao = descricaoController.text.trim();
                    String endereco = enderecoController.text.trim();

                    String apikeyMap = EnvVariables().mapsKey;

                    print("chave de api: $apikeyMap");

                    if (endereco.isEmpty) {
                      print("⚠️ Endereço vazio. Digite um endereço válido.");
                      return;
                    }

                    print("Endereço digitado: $endereco");

                    try {
                      final response = await http.get(Uri.parse(
                          'https://maps.googleapis.com/maps/api/geocode/json?address=$endereco&key=$apikeyMap'));

                      if (response.statusCode == 200) {
                        List<dynamic> locations =
                            json.decode(response.body)['results'];

                        print("Endereço digitado: $locations");

                        if (locations.isEmpty) {
                          print(
                              "Nenhuma localização encontrada para: $endereco");
                          return;
                        }

                        var location = locations.first['geometry']['location'];
                        double latitude = location['lat'];
                        double longitude = location['lng'];

                        print(
                            'Localização encontrada! Latitude: $latitude, Longitude: $longitude');

                        final insertResponse = await Supabase.instance.client
                            .from('contatos')
                            .insert({
                          'nome_contato': nome,
                          'numero_telefone': numero,
                          'contato_descricao': descricao,
                          'latitude': latitude,
                          'longitude': longitude,
                        });

                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      print("Erro ao obter localização: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(width: 5, color: Colors.black),
                    ),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
