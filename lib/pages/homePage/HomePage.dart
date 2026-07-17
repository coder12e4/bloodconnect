import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/home_controller.dart';
import 'app_drawer.dart';
import 'donor_list_view.dart';
import 'donor_map_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Donors"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDonors,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _BloodGroupFilterBar(controller: controller),
          Expanded(
            child: Obx(
                  () => controller.currentTabIndex.value == 0
                  ? const DonorMapView()
                  : const DonorListView(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "List",
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodGroupFilterBar extends StatelessWidget {
  final HomeController controller;

  const _BloodGroupFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: controller.bloodGroupOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final group = controller.bloodGroupOptions[index];

          // Each chip gets its own Obx so the reactive read happens
          // synchronously inside this builder, not the outer (lazy) list.
          return Obx(() {
            final isSelected = controller.selectedBloodGroup.value == group;
            return ChoiceChip(
              label: Text(group),
              selected: isSelected,
              onSelected: (_) => controller.filterByBloodGroup(group),
              selectedColor: Colors.red.shade100,
              labelStyle: TextStyle(
                color: isSelected ? Colors.red.shade900 : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          });
        },
      ),
    );
  }
}