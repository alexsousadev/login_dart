import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

// Retorna a localização atual do dispositivo
Future<LatLng> localizacaoAtual() async {
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
createCustomMarker(LatLng location, String titleMarker, String snippet,
    String iconPath) async {
  final String id = const Uuid().v4();

  BitmapDescriptor customIcon = await addCustomIcon(iconPath);

  return {
    Marker(
      markerId: MarkerId(id),
      position: location,
      icon: customIcon,
      infoWindow: InfoWindow(
        title: titleMarker,
        snippet: snippet,
      ),
    ),
  };
}
