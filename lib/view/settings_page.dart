import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/common/navigation.dart';
import 'package:restoro_fav_app/provider/preferences_provider.dart';
import 'package:restoro_fav_app/provider/reminder_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(builder: (_, provider, __) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Settings')),
        ),
        body: ListView(
          children: [
            Material(
              child: ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: const Text('Daily Reminder'),
                trailing: Consumer<ReminderProvider>(
                    builder: (context, scheduled, _) {
                      return Switch.adaptive(
                        value: provider.isDailyReminderActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Coming Soon!'),
                                  content: const Text(
                                      'This feature will be coming soon!'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigation.back();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            scheduled.scheduledNews(value);
                            provider.enableDailyReminder(value);
                          }
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      );
    });
  }
}

