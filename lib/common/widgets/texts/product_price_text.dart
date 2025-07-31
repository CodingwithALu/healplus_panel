import 'package:flutter/material.dart';
class TProductPriceText extends StatelessWidget {
  const TProductPriceText({
    super.key,
    this.currencySign = '\$',
    required this.price,
    this.maxLight = 1,
    this.isLarge = false,
    this.lineThrough = false,
  });

  final String currencySign, price;
  final int maxLight;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLight,
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      )
          : Theme.of(context).textTheme.titleLarge!.apply(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}