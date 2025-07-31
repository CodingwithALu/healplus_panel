import 'package:healplus_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated
        ? null
        : const RouteSettings(name: TRoutes.login);
  }
}
