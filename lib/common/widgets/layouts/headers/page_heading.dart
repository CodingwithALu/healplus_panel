import 'package:flutter/material.dart';

class TPageHeading extends StatelessWidget {
  const TPageHeading({
    super.key,
    required this.heading,
    this.rightSideWidget,
    required this.titleSmall,
  });
  final String heading;
  final Widget? rightSideWidget;
  final bool titleSmall;
  @override
  Widget build(BuildContext context) {
    // implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        titleSmall
            ? Text(heading, style: Theme.of(context).textTheme.headlineSmall)
            : Text(heading, style: Theme.of(context).textTheme.headlineLarge),
        rightSideWidget ?? const SizedBox(),
      ],
    );
  }
}
