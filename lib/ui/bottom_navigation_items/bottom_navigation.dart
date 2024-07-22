import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/generated/assets.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/booking/booking_page.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/profile/profile_page.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/search/search_page.dart';
import 'package:flutter_demo_structure/values/extensions/widget_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/l10n.dart';
import '../../values/colors.dart';
import '../../values/style.dart';
import 'home/home_page.dart';

@RoutePage()
class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int selectedIndex = 0;
  List pages = [
    HomePage(),
    BookingPage(),
    SearchPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -4),
              color: AppColor.black.withOpacity(0.07),
              blurRadius: 26.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedIconTheme: IconThemeData(
            color: AppColor.green,
            fill: 1,
          ),
          selectedItemColor: AppColor.green,
          selectedLabelStyle: textMedium.copyWith(
            fontSize: 11.spMin,
            color: AppColor.green,
          ),
          unselectedItemColor: AppColor.starNonSelectedColor,
          unselectedIconTheme:
              IconThemeData(color: AppColor.starNonSelectedColor, fill: 0),
          unselectedLabelStyle: textRegular.copyWith(
              fontSize: 11.spMin, color: AppColor.starNonSelectedColor),
          iconSize: 20.r,
          currentIndex: selectedIndex,
          onTap: (val) {
            setState(() {
              selectedIndex = val;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.white,
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(Assets.imageBottomHome))
                    .wrapPaddingOnly(bottom: 4),
                activeIcon: ImageIcon(AssetImage(Assets.imageBottomHomeFilled))
                    .wrapPaddingOnly(bottom: 4),
                label: S.of(context).home),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(Assets.imageBottomCalender))
                    .wrapPaddingOnly(bottom: 4),
                label: S.of(context).myBookings2),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(Assets.imageBottomSearch))
                    .wrapPaddingOnly(bottom: 4),
                label: S.of(context).search),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(Assets.imageBottomPerson))
                    .wrapPaddingOnly(bottom: 4),
                label: S.of(context).profile),
          ],
        ),
      ),
    );
  }
}
