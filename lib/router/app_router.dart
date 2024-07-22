import 'package:auto_route/auto_route.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_demo_structure/core/locator/locator.dart';
import 'package:flutter_demo_structure/ui/splash/splash_page.dart';

import '../ui/authentication/login/login_page.dart';
import '../ui/authentication/sign_up/signup_form.dart';
import '../ui/authentication/sign_up/signup_page.dart';
import '../ui/bottom_navigation_items/bottom_navigation.dart';
import '../ui/bottom_navigation_items/home/home_page.dart';
import '../ui/bottom_navigation_items/home/house_cleaning_details.dart';
import '../ui/bottom_navigation_items/home/service_list_details.dart';
import '../ui/image_picker/image_picker.dart';
import '../ui/image_picker/show_uploaded_image.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page),
    AutoRoute(page: SignUpFormRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: HouseCleaningDetailsRoute.page),
    AutoRoute(page: ServiceListDetailsRoute.page),
    AutoRoute(page: BottomNavigationBarRoute.page),
    AutoRoute(page: ImagePickerRoute.page, initial: true),
    AutoRoute(page: ShowUploadedImageRoute.page),
    // AutoRoute(page: LoginRoute.page),
    // AutoRoute(page: SignUpRoute.page),
  ];
}

final appRouter = locator<AppRouter>();
