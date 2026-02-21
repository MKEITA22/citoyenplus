import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    // ✅ Settings Linux obligatoires quand on développe sur Linux
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        linux: linuxSettings, // ✅ Ajouté
      ),
    );

    // Demande la permission selon la plateforme cible (téléphone)
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Affiche une notification immédiate
  static Future<void> show({
    required String titre,
    required String corps,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titre,
      corps,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'citoyen_plus_channel',
          'Citoyen +',
          channelDescription: 'Notifications de l\'application Citoyen +',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
        linux: LinuxNotificationDetails(), // ✅ Ajouté
      ),
    );
  }
}