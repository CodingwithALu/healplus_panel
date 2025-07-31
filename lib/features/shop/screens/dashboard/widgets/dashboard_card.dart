import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:healplus_panel/common/widgets/texts/section_heading.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TDashbosrCard extends StatelessWidget {
  const TDashbosrCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Iconsax.arrow_up_3,
    this.color = TColors.success,
    required this.stas,
    this.onTap,
    required this.context,
    required this.headingIcons,
    required this.headingIconColors,
    required this.headingIconBgColor,
    required this.comparedText,
  });
  final BuildContext context;
  final String title, subtitle, comparedText;
  final IconData icon, headingIcons;
  final Color color, headingIconColors, headingIconBgColor;
  final int stas;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Heading
          Row(
            children: [
              TCircularIcon(
                icon: headingIcons,
                backgroundColor: headingIconBgColor,
                color: headingIconColors,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              TSectionHeading(
                title: title,
                textColor: TColors.textSecondary,
                showActionButton: false,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subtitle, style: Theme.of(context).textTheme.headlineSmall),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Indicator
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color, size: TSizes.iconSm),
                        Text(
                          '$stas%',
                          style: Theme.of(context).textTheme.titleSmall!.apply(
                            color: color,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      comparedText,
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
