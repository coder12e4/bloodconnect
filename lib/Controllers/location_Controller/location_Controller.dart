// Requires: geolocator
// Add to pubspec.yaml:
//   geolocator: ^13.0.1
//
// Android (AndroidManifest.xml) — inside <manifest>:
//   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
//   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//
// iOS (Info.plist):
//   <key>NSLocationWhenInUseUsageDescription</key>
//   <string>We use your location to find nearby donors/requesters.</string>

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocationController extends GetxService {
  final RxBool isUpdating = false.obs;
  final Rx<Position?> lastPosition = Rx<Position?>(null);
  final RxString lastError = "".obs;
  RxDouble lat=00.00.obs;
  RxDouble long=00.00.obs;

 late String _uid ;

  /// Call this to update location once. Fire-and-forget from the caller's
  /// point of view — it won't block whatever triggered it, and swallows
  /// errors internally (logged via lastError) so a failed GPS/network read
  /// never crashes the calling flow.

  void getPosition()async{
    final hasPermission = await _ensurePermission();
    if (!hasPermission) {
      lastError.value = "Location permission denied";
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

     lat=position.latitude.obs;
     long=position.longitude.obs;

    lastPosition.value = position;
  }
  void updateCurrentLocationInBackground() {
    // Deliberately not awaited by design — runs in the background relative
    // to the caller. Call `await updateCurrentLocation()` directly instead
    // if you need to know when it's done.
    unawaited(updateCurrentLocation());
  }

  /// Does the actual work: checks permission, reads GPS, writes to Firestore.
  Future<bool> updateCurrentLocation() async {

    final box = GetStorage();
    _uid=box.read("userId")??"false";
    if (_uid == null) {
      lastError.value = "No logged-in user";
      return false;
    }

    isUpdating.value = true;
    try {
      final hasPermission = await _ensurePermission();
      if (!hasPermission) {
        lastError.value = "Location permission denied";
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lastPosition.value = position;

      await FirebaseFirestore.instance.collection("users").doc(_uid).update({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      lastError.value = "";
      return true;
    } catch (e) {
      lastError.value = e.toString();
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Starts a repeating background loop that updates location every
  /// [interval] (default 5 minutes) for as long as the app process is alive.
  /// Note: this is NOT a true OS-level background service — it stops if the
  /// app is killed. For updates while the app is fully closed/minimized for
  /// a long time, pair this with flutter_foreground_task (like you used for
  /// the server app) or WorkManager.


  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  @override
  void onClose() {

    super.onClose();
  }
}