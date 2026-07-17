import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              child: ListTile(
                leading: CircleAvatar(
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
                ),
                title: Text(donor.name.isNotEmpty ? donor.name : "Unnamed"),
                subtitle: Text(
                  "${donor.district}, ${donor.place}".trim(),
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(donor.bloodGroup),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.red.shade50,
                      labelStyle: const TextStyle(color: Colors.red),
                    ),
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: donor.isAvailable ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to donor detail screen if you have one.
                },
              ),
            );
          },
        ),
      );
    });
  }
}
