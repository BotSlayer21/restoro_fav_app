import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restoro_fav_app/utils/background_service.dart';
import 'package:restoro_fav_app/utils/date_time_helper.dart';

class ReminderProvider extends ChangeNotifier {
  bool _isReminded = false;

  bool get isReminded => _isReminded;

  Future<bool> scheduledNews(bool value) async {
    _isReminded = value;
    if (_isReminded) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}