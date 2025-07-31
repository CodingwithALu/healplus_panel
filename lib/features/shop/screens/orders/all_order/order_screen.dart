import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/orders/all_order/reponsive_screen/order_desktop_screen.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //implement build
    return TSizeTemplate(desktop: OrderDesktopScreen());
  }
}
