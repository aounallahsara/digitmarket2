import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:digit_market/gestioncommande.dart';
import 'package:digit_market/homepage.dart';
import 'package:digit_market/notification.dart';
import 'package:digit_market/profileclient.dart';
import 'package:digit_market/searchpage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageClient extends StatefulWidget {
  const HomePageClient({Key? key}) : super(key: key);

  @override
  State<HomePageClient> createState() => _HomePageClientState();
}

class _HomePageClientState extends State<HomePageClient> {
  final GlobalKey navigationKey = GlobalKey();
  int index = 0;

  final screens = [
    HomeContentPageClient(),
    Gestiondecommande(),
    ProductSearchPage(),
    NotificationPage(),
    ProfilePageClient(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.home,
      Icons.shopping_bag,
      Icons.search,
      Icons.notifications,
      Icons.person,
    ];
    final items = List.generate(icons.length, (i) {
      return Icon(
        icons[i],
        size: 30.sp,
        color: i == index ? Colors.white : Colors.white70,
      );
    });

    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          key: navigationKey,
          index: index,
          height: 60,
          items: items,
          color: Colors.green,
          buttonBackgroundColor: Colors.green,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
        ),
      ),
    );
  }
}
