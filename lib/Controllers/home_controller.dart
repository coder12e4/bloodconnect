import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'location_Controller/location_Controller.dart';

/// Simple model mapped from the Firestore "users" collection.
class DonorModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String bloodGroup;
  final String gender;
  final String district;
  final String place;
  final double? latitude;
  final double? longitude;
  final String profileImage;
  final bool isAvailable;
  final String role;

  /// Distance from the current user in kilometers.
  /// Populated at runtime after fetching; not stored in Firestore.
  double? distanceKm;

  DonorModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.gender,
    required this.district,
    required this.place,
    this.latitude,
    this.longitude,
    required this.profileImage,
    required this.isAvailable,
    required this.role,
    this.distanceKm,
  });

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    return DonorModel(
      uid: map['uid'] ?? '',
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      bloodGroup: (map['bloodGroup'] ?? '').toString(),
      gender: (map['gender'] ?? '').toString(),
      district: (map['district'] ?? '').toString(),
      place: (map['place'] ?? '').toString(),
      latitude: double.tryParse((map['latitude'] ?? '').toString()),
      longitude: double.tryParse((map['longitude'] ?? '').toString()),
      profileImage: (map['profileImage'] ?? '').toString(),
      isAvailable: map['isAvailable'] == true,
      role: (map['role'] ?? 'donor').toString(),
    );
  }
}

class HomeController extends GetxController {
  // Raw + filtered lists
  final RxList<DonorModel> allDonors = <DonorModel>[].obs;
  final RxList<DonorModel> filteredDonors = <DonorModel>[].obs;

  // Filter state
  final RxString selectedBloodGroup = "All".obs;

  // Bottom nav: 0 = Map, 1 = List
  final RxInt currentTabIndex = 0.obs;

  final RxBool isLoading = false.obs;

  final List<String> bloodGroupOptions = const [
    "All",
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  final locationController = Get.put(LocationController(), permanent: true);

  @override
  void onInit() {
    super.onInit();

    locationController.updateCurrentLocationInBackground();
    fetchDonors();

    // Re-sort automatically once the user's live location becomes available
    // or updates. Adjust the property names below to match your
    // LocationController's actual reactive fields.
    ever(locationController.lat, (_) => _applyFilter());
    ever(locationController.long, (_) => _applyFilter());
  }

  /// Fetch all donor users from Firestore.
  Future<void> fetchDonors() async {
    isLoading.value = true;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: "donor")
          .get();

      final donors =
      snapshot.docs.map((doc) => DonorModel.fromMap(doc.data())).toList();

      allDonors.assignAll(donors);
      _applyFilter();
    } catch (e) {
      Get.snackbar("Error", "Failed to load donors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDonors() => fetchDonors();

  void filterByBloodGroup(String group) {
    selectedBloodGroup.value = group;
    _applyFilter();
  }

  void _applyFilter() {
    List<DonorModel> result;

    if (selectedBloodGroup.value == "All") {
      result = List<DonorModel>.from(allDonors);
    } else {
      result = allDonors
          .where((d) => d.bloodGroup == selectedBloodGroup.value)
          .toList();
    }

    _sortByDistance(result);

    filteredDonors.assignAll(result);
  }

  /// Computes distanceKm for each donor relative to the current user
  /// location, then sorts the list ascending (nearest first).
  /// Donors with missing coordinates, or when the user's location isn't
  /// available yet, are pushed to the end of the list.
  void _sortByDistance(List<DonorModel> donors) {
    final double? userLat = locationController.lat.value;
    final double? userLng = locationController.long.value;

    if (userLat == null || userLng == null) {
      for (final d in donors) {
        d.distanceKm = null;
      }
      return;
    }

    for (final d in donors) {
      if (d.latitude != null && d.longitude != null) {
        d.distanceKm = _haversineKm(
          userLat,
          userLng,
          d.latitude!,
          d.longitude!,
        );
      } else {
        d.distanceKm = null;
      }
    }

    donors.sort((a, b) {
      if (a.distanceKm == null && b.distanceKm == null) return 0;
      if (a.distanceKm == null) return 1; // unknown distance goes last
      if (b.distanceKm == null) return -1;
      return a.distanceKm!.compareTo(b.distanceKm!); // ascending
    });
  }

  /// Great-circle distance between two lat/lng points, in kilometers.
  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}