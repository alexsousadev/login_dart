import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

// Retorna a localização atual do dispositivo
Future<LatLng> localizacaoAtual() async {
  // checando se o serviço de localização está ativo
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception('Serviço de localização desabilitado');
  }

  // checando permissão para o maps
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Permisão negada');
    }
  }

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 5),
    ),
  );

  return LatLng(position.latitude, position.longitude);
}

// Função para criar um marcador comum
Set<Marker> createMarker(LatLng location, String title_marker, String snippet) {
  final String id = const Uuid().v4();

  return {
    Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: title_marker,
        snippet: snippet,
      ),
    ),
  };
}

// Cria um ícone personalizado
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
          },
        );
      },
    ),
  };
}

// botão para traçar a rota
Align buttonRota(LatLng location) {
  return Align(
    alignment: Alignment.centerRight,
    child: IconButton(
      icon: Icon(Icons.directions),
      iconSize: 35,
      onPressed: () {},
    ),
  );
}
