// Requires: flutter_map, latlong2
// Add to pubspec.yaml:
//   flutter_map: ^7.0.2
//   latlong2: ^0.9.1

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../Controllers/home_controller.dart';


class DonorMapView extends StatelessWidget {
  const DonorMapView({super.key});

  static const LatLng _keralaCenter = LatLng(10.8505, 76.2711);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final donorsWithLocation = controller.filteredDonors
          .where((d) => d.latitude != null && d.longitude != null)
          .toList();

      return FlutterMap(
        options: const MapOptions(
          initialCenter: _keralaCenter,
          initialZoom: 7.5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.yourapp.package", // update this
          ),
          MarkerLayer(
            markers: donorsWithLocation.map((donor) {
              return Marker(
                point: LatLng(donor.latitude!, donor.longitude!),
                width: 42,
                height: 42,
                child: GestureDetector(
                  onTap: () => _showDonorSheet(context, donor),
                  child: Icon(
                    Icons.location_on,
                    size: 36,
                    color: donor.isAvailable ? Colors.red : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  void _showDonorSheet(BuildContext context, DonorModel donor) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(donor.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text("${donor.district}, ${donor.place}"),
            const SizedBox(height: 8),
            Chip(label: Text(donor.bloodGroup)),
          ],
        ),
      ),
    );
  }
}
