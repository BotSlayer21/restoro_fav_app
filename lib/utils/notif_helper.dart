import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:restoro_fav_app/common/navigation.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          final payload = details.payload;
          if (payload != null) {
            // ignore: avoid_print
            print('notification payload: $payload');
          }
          selectNotificationSubject.add(payload ?? 'empty payload');
        });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "RESTORO APP";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var localRestaurant = await ApiService(client: Client()).restaurantList();
    var restaurantList = localRestaurant.restaurants;

    var randomIndex = Random().nextInt(restaurantList.length);
    var randomRestaurant = restaurantList[randomIndex];

    var titleNotification = "<b>Daily Reminder</b>";
    var titleNews = randomRestaurant.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: randomRestaurant.id);
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
          (String payload) async {
        Navigation.intentWithData(route, {
          'id': payload,
        });
      },
    );
  }
}