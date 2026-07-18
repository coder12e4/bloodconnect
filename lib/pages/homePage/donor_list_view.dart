import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/home_controller.dart';

class DonorListView extends StatelessWidget {
  const DonorListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredDonors.isEmpty) {
        return const Center(child: Text("No donors found"));
      }

      return RefreshIndicator(
        onRefresh: controller.refreshDonors,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.filteredDonors.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final donor = controller.filteredDonors[index];
            return Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                
                      children: [
                        CircleAvatar(
                          backgroundImage: donor.profileImage.isNotEmpty
                              ? NetworkImage(donor.profileImage)
                              : null,
                          child: donor.profileImage.isEmpty
                              ? Text(
                            donor.name.isNotEmpty
                                ? donor.name[0].toUpperCase()
                                : "?",
                          )
                              : null,
                        ), SizedBox(width: 8,),Text(donor.name.isNotEmpty ? donor.name : "Unnamed"),

                        Spacer(), Chip(
                          label: Text(donor.bloodGroup),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.red.shade50,
                          labelStyle: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                
                      children: [
                        Text(
                          "${donor.district}, ${donor.place}".trim(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                
                        Text("Is Available"),
                        Icon(
                          Icons.circle,
                          size: 20,
                          color: donor.isAvailable ? Colors.green : Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _launchCall(context, donor.phone),
                          icon: const Icon(Icons.call),
                          label: const Text("Call"),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => _launchWhatsApp(context, donor.phone),
                          icon: const Icon(Icons.chat),
                          label: const Text("WhatsApp"),
                        ),
                      ],
                    )
                
                
                
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

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
