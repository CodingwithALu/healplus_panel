import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TWeeklySalesGraph extends StatelessWidget {
  const TWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(DashboardController());
    final local = AppLocalizations.of(context)!;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.wallet,
                backgroundColor: Colors.blueAccent.withAlpha(100),
                color: Colors.blueAccent,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                local.weeklySales,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          // Graph
          Obx(
            () => controller.weeklySales.isNotEmpty
                ? SizedBox(
                    height: 400,
                    // Bieu do thanh
                    child: BarChart(
                      // Bieu do du lieu
                      BarChartData(
                        titlesData: buildFlTitlesData(
                          controller.weeklySales,
                          context,
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            top: BorderSide.none,
                            right: BorderSide.none,
                          ),
                        ),
                        gridData: const FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                          horizontalInterval: 200,
                        ),
                        barGroups: controller.weeklySales
                            .asMap()
                            .entries
                            .map(
                              // nhap muc cho moi thanh du lieu
                              (entry) => BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    width: 30,
                                    toY: entry.value,
                                    color: TColors.primary,
                                    borderRadius: BorderRadius.circular(
                                      TSizes.sm,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        // Khoang cach du cac thanh
                        groupsSpace: TSizes.spaceBtwItems,
                        // Co the tuong tac voi du lieu va hien thi
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => TColors.secondary,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                rod.toY.toStringAsFixed(
                                  2,
                                ), // Hiển thị 2 chữ số thập phân
                                TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          touchCallback: TDeviceUtils.isDesktopScreen(context)
                              ? (barTouchEvent, barTouchResponse) {}
                              : null,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [TLoaderAnimation()],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  FlTitlesData buildFlTitlesData(
    List<double> weeklySales,
    BuildContext context,
  ) {
    double maxOrder = weeklySales.reduce((a, b) => a > b ? a : b).toDouble();
    double stepHeight = (maxOrder / 10).ceilToDouble();
    final localizations = AppLocalizations.of(context)!;
    final days = [
      localizations.monday,
      localizations.tuesday,
      localizations.wednesday,
      localizations.thursday,
      localizations.friday,
      localizations.saturday,
      localizations.sunday,
    ];
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          // Hien thi thanh tieu de
          getTitlesWidget: (value, meta) {
            // Calulate the index and ensure it wraps around for the correct day
            final index = value.toInt() % days.length;
            // Get the day corresponding to the calculated index
            final day = days[index];
            return SideTitleWidget(space: 0, meta: meta, child: Text(day));
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: stepHeight <= 0 ? 500 : stepHeight,
          reservedSize: 50,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
