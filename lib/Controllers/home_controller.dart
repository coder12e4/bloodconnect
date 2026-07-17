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
    if (selectedBloodGroup.value == "All") {
      filteredDonors.assignAll(allDonors);
    } else {
      filteredDonors.assignAll(
        allDonors
            .where((d) => d.bloodGroup == selectedBloodGroup.value)
            .toList(),
      );
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
