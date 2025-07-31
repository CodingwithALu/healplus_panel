import 'package:healplus_panel/common/widgets/layouts/headers/header.dart';
import 'package:healplus_panel/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: TSizebar()),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // Header
                THeader(),
                // Body
                Expanded(
                  child: Container(
                    color: TColors.darkerGrey, // Change background color here
                    child: body ?? const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
