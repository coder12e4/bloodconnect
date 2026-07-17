import 'package:get/get.dart';

import '../../Controllers/forgetPasswordController.dart';

class forgetPasswordBinding extends Bindings{
  @override
  void dependencies() {


    Get.lazyPut(()=>forgetPasswordController());
    // TODO: implement dependencies

  }

}