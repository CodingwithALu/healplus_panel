import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/authentication/screens/signup/reponsive_sreen/signup_destop_tablet.dart';
import 'package:healplus_panel/features/authentication/screens/signup/reponsive_sreen/signup_mobile.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return TSizeTemplate(
      useLayout: false,
      desktop: SignupDestopTablet(),
      mobile: SignupMobile(),
    );
  }
}
