import 'package:flutter/material.dart';
import 'package:restoro_fav_app/utils/notif_helper.dart';
import 'package:restoro_fav_app/view/resto_detail_page.dart';
import 'package:restoro_fav_app/view/resto_fav.dart';
import 'package:restoro_fav_app/view/resto_list.dart';
import 'package:restoro_fav_app/view/settings_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();
  final List<Widget> _listWidget = [
    const RestaurantList(),
    const RestaurantFavorite(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}