import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controller/contatos.controller.dart';
import 'package:flutter_application_1/src/controller/mapa.controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? mapController;
  final LatLng ifpi = const LatLng(-5.08921, -42.8016);
  LatLng currentPosition = const LatLng(-5.089308, -42.811028);
  bool isLoading = false;
  String? errorMessage;

  // marcadores e polyline
  final Set<Marker> _marcadores = {};
  List<dynamic> contatos = [];
  final Set<Polyline> _polylines = {};

  ContatosController contatosController =
      ContatosController(Supabase.instance.client);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    initContatos();
  }

  // Realiza as marcações dos contatos
  void initContatos() async {
    final listaContatos = await contatosController.listarContatos();
    contatos = listaContatos;

    for (var i = 0; i < listaContatos.length; i++) {
      final location = LatLng(double.parse(listaContatos[i]['latitude']),
          double.parse(listaContatos[i]['longitude']));
      final nome = listaContatos[i]['nome_contato'];
      final descricao = listaContatos[i]['contato_descricao'];

      final markers = await createCustomMarker(
          context, location, nome, descricao, "marker-blue.png");
      setState(() {
        _marcadores.addAll(markers);
      });
    }
  }

  // Capta a posição atual do usuário
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final location = await localizacaoAtual();
      print("você está aqui: $location");

      setState(() {
        currentPosition = location;
      });

      final currentMarker = await createCustomMarker(
          context, currentPosition, "Você", "Você está aqui", "you.png");

      setState(() {
        _marcadores.addAll(currentMarker);
      });

      // atualiza a visão para o usuário
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15,
        ),
      ));
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao obter localização: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addPolylineToMap(Polyline polyline) {
    setState(() {
      _polylines.add(polyline);
    });
  }

  Future<BitmapDescriptor> addCustomIcon(String customIcon) async {
    return await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), customIcon);
  }

// Função para criar um marcador personalizado
  Future<Set<Marker>> createCustomMarker(BuildContext context, LatLng location,
      String titleMarker, String snippet, String iconPath) async {
    final String id = const Uuid().v4();
    BitmapDescriptor customIcon = await addCustomIcon(iconPath);

    return {
      Marker(
        markerId: MarkerId(id),
        position: location,
        icon: customIcon,
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (builder) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              titleMarker,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          buttonRota(location),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        snippet,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    };
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
              markers: _marcadores,
              polylines: _polylines,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
