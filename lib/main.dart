import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'liveupdate/live_update_notifier.dart'; // سنحتفظ به للتوافق لكن سنعدل

void main() {
  runApp(OwnBarApp());
}

class OwnBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.example.own_bar/service');

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // طلب صلاحية النافذة العائمة
    bool overlayGranted = await platform.invokeMethod('startOverlayService');
    // طلب صلاحية قراءة الإشعارات إن لم تكن مفعلة
    bool listenerEnabled = await platform.invokeMethod('isNotificationListenerEnabled');
    if (!listenerEnabled) {
      await platform.invokeMethod('openNotificationSettings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Own Bar')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await platform.invokeMethod('startOverlayService');
          },
          child: Text('تشغيل الجزيرة الديناميكية'),
        ),
      ),
    );
  }
}
