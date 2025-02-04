import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controller/contatos.controller.dart';
import 'package:flutter_application_1/src/controller/mapa.controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? mapController;
  final LatLng ifpi = const LatLng(-5.08921, -42.8016);
  LatLng currentPosition = const LatLng(-5.08922, -42.8016);
  bool isLoading = false;
  String? errorMessage;

  // Lista de marcadores
  final Set<Marker> _marcadores = {};

  // Lista de contatos
  List<dynamic> contatos = [];

  // Instancia do controller de contatos
  ContatosController contatosController =
      ContatosController(Supabase.instance.client);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    initContatos();
  }

  // criando os marcadores dos contatos
  void initContatos() async {
    final listaContatos = await contatosController.listarContatos();
    contatos = listaContatos;

    for (var i = 0; i < listaContatos.length; i++) {
      final location = LatLng(double.parse(listaContatos[i]['latitude']),
          double.parse(listaContatos[i]['longitude']));
      final nome = listaContatos[i]['nome_contato'];
      final descricao = listaContatos[i]['contato_descricao'];

      // Aguarde a criação dos marcadores
      final markers = await createCustomMarker(
          location, nome, descricao, "marker-blue.png");
      _marcadores.addAll(markers); // Adiciona os marcadores ao conjunto
    }
    setState(() {});

    // Aguarde a criação do marcador atual
    final currentMarker = await createCustomMarker(
        currentPosition, "Você", "Você está aqui", "you.png");
    _marcadores.addAll(currentMarker);
    setState(() {});
  }

  // Método para obter a localização atual
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final location = await localizacaoAtual();
      setState(() {
        currentPosition = location;
        // Limpa os marcadores antigos
        _marcadores.clear();
      });

      // Aguarde a criação do marcador atual
      final currentMarker = await createCustomMarker(
          currentPosition, "Você", "Você está aqui", "you.png");
      setState(() {
        _marcadores.addAll(currentMarker); // Adiciona o marcador atual
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao obter localização: $e";
      });
    } finally {
      setState(() {
        isLoading = false; // Atualiza o estado de loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          // if (isLoading) const LinearProgressIndicator(),
          if (errorMessage != null)
            Container(
              color: Colors.red.withAlpha((0.1 * 255).round()),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: ifpi,
                  zoom: 11,
                ),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                markers: _marcadores.map((e) => e).toSet()),
          ),
        ],
      ),
    );
  }
}
