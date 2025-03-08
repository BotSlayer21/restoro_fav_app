import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/common/navigation.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/data/db/db_helper.dart';
import 'package:restoro_fav_app/data/preferences/preferences_helper.dart';
import 'package:restoro_fav_app/provider/db_provider.dart';
import 'package:restoro_fav_app/provider/preferences_provider.dart';
import 'package:restoro_fav_app/provider/reminder_provider.dart';
import 'package:restoro_fav_app/utils/background_service.dart';
import 'package:restoro_fav_app/utils/notif_helper.dart';
import 'package:restoro_fav_app/view/customer_review.dart';
import 'package:restoro_fav_app/view/home_page.dart';
import 'package:restoro_fav_app/view/resto_detail_page.dart';
import 'package:restoro_fav_app/view/customer_add_review.dart';
import 'package:restoro_fav_app/provider/resto_detail_provider.dart';
import 'package:restoro_fav_app/provider/resto_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService(client: Client())),
        ),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
      ],
      child: Consumer<PreferencesProvider>(builder: (_, provider, __) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'RESTORO APP',
          theme: provider.themeData,
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (_) =>
                ChangeNotifierProvider<RestaurantProvider>(
                  create: (_) => RestaurantProvider(apiService: ApiService(client: Client())),
                  child: const HomePage(),
                ),
            RestaurantDetailPage.routeName: (context) {
              final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
              return ChangeNotifierProvider<RestaurantDetailProvider>(
                create: (_) => RestaurantDetailProvider(
                    apiService: ApiService(client: Client()), id: args['id'] as String),
                child: const RestaurantDetailPage(),
              );
            },
            CustomerReviews.routeName: (context) {
              final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
              return ChangeNotifierProvider<RestaurantDetailProvider>(
                create: (_) => RestaurantDetailProvider(
                    apiService: ApiService(client: Client()), id: args['id'] as String),
                child: CustomerReviews(
                  id: args['id'] as String,
                ),
              );
            },
            AddReview.routeName: (context) {
              final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
              return AddReview(
                id: args['id'] as String,
              );
            },
          },
        );
      }),
    );
  }
}
