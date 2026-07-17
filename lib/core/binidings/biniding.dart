import 'package:bloodconnect/Controllers/splashControllers.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
      Get.put<SplashController>(SplashController());
    // TODO: implement dependencies
    //  Get.lazyPut(   fenix: true);
  }
}