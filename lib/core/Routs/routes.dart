import 'package:bloodconnect/core/binidings/home_Page_binding.dart';
import 'package:bloodconnect/core/binidings/login_binding.dart';
import 'package:bloodconnect/pages/auth/forgot_password_page.dart';
import 'package:bloodconnect/pages/auth/login.dart';
import 'package:bloodconnect/pages/auth/register.dart';
import 'package:bloodconnect/pages/homePage/HomePage.dart';
import 'package:get/get.dart';

import '../../pages/auth/register.dart';
import '../../pages/splash.dart';
import '../binidings/biniding.dart';
import '../binidings/forget_password_binding.dart';
import '../binidings/regiter_binding.dart';

class AppRoutes{
  static  String Initial="/splash";
  static  String Login="/login";
  static String Register="/register";
  static String forgotPassword="/forgotPassword";
  static String home="/home";

  static String getInitial()=>Initial;
  static String getLogin()=>Login;
  static String getRegister()=>Register;
  static String getForgotPassword()=>"/forgotPassword";

  static List<GetPage> appPages = <GetPage>[
    GetPage(
      name: AppRoutes.Initial,
      page: () => const Splash(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.Register,
      page: () => DonorRegistrationPage(),
      binding: DonorBinding(),
    ),

    GetPage(name: AppRoutes.Login,
        page:()=>LoginPage(),
    binding: LoginBinding()
    ),

    GetPage(name: AppRoutes.forgotPassword,
        page:()=>ForgotPasswordPage(),
        binding: forgetPasswordBinding()
    ),

    GetPage(
        name: AppRoutes.home,
        page: ()=>HomeScreen(),
        binding: homePageBinding()
    )

  ];

}