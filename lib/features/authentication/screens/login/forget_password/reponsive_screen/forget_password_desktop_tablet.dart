import 'package:healplus_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:healplus_panel/features/authentication/screens/login/forget_password/widgets/header_from.dart';
import 'package:flutter/material.dart';

class ForgetPasswordDesktopTablet extends StatelessWidget {
  const ForgetPasswordDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return TLoginTemplate(child: HeaderAndForm());
  }
}
