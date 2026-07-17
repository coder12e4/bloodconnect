import 'package:bloodconnect/Controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../Controllers/location_Controller/location_Controller.dart';

class homePageBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(()=>HomeController());
   Get.lazyPut(()=>(LocationController(), permanent: true));
  }

}