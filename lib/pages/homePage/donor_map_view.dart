// Requires: flutter_map, latlong2
// Add to pubspec.yaml:
//   flutter_map: ^7.0.2
//   latlong2: ^0.9.1

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
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

      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: FlutterMap(
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
        ),
      );
    });
  }



  void _showDonorSheet(BuildContext context, DonorModel donor) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(donor.name, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text("${donor.district}, ${donor.place}"),
            const SizedBox(height: 8),
            Chip(label: Text(donor.bloodGroup)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchCall(context, donor.phone),
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchWhatsApp(context, donor.phone),
                    icon: const Icon(Icons.chat),
                    label: const Text("WhatsApp"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Strips spaces, dashes, parentheses, etc., leaving only digits and a
  /// leading '+' if present.
  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<void> _launchCall(BuildContext context, String phone) async {
    final cleaned = _cleanPhone(phone);
    if (cleaned.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No phone number available")),
      );
      return;
    }

    final uri = Uri(scheme: 'tel', path: cleaned);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open dialer")),
        );
      }
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String phone) async {
    var cleaned = _cleanPhone(phone);
    if (cleaned.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No phone number available")),
      );
      return;
    }

    // wa.me requires the number in international format without '+' or
    // leading zeros. Adjust the default country code (91 = India) if your
    // donor numbers aren't stored with a country code already.
    cleaned = cleaned.replaceFirst('+', '');
    if (!cleaned.startsWith('91') && cleaned.length == 10) {
      cleaned = '91$cleaned';
    }

    final uri = Uri.parse("https://wa.me/$cleaned");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp")),
        );
      }
    }
  }
}
