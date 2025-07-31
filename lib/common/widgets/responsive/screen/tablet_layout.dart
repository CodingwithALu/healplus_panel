import 'package:healplus_panel/common/widgets/layouts/headers/header.dart';
import 'package:healplus_panel/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});
  final Widget? body;
  final GlobalKey<ScaffoldState> scalloldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scalloldKey,
      drawer: const TSizebar(),
      appBar: THeader(scaffoldKey: scalloldKey),
      body: Container(
        color: TColors.darkerGrey, // Change background color here
        child: body ?? const SizedBox(),
      ),
    );
  }
}
