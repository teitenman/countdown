import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'events.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => TopPageState();
}

class TopPageState extends State<TopPage> {
  final Map<int, Duration> _countdowns = {};
  Timer? _timer;

  void _doCountdown(DateTime target) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Events.eventsList.isEmpty) return;
      final now = DateTime.now();
      setState(() {
        for (int i = 0; i < Events.eventsList.length; i++) {
          final event = Events.eventsList[i];
          final diff = DateTime(
            event.year,
            event.month,
            event.date,
            event.hour,
            event.minute,
          ).difference(now);
          if (diff.isNegative) {
            _countdowns[i] = Duration.zero;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (!mounted) return;
                _passedEventProcess(event, context);
              });
            });
            // _showPassedNotification(event.title);
          } else {
            _countdowns[i] = diff;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    loadEvents().then((_) {
      setState(() {}); // データロード後に画面を更新
    });
    isLoaded().then((_) {
      setState(() {});
    });
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showPassedNotification(String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'countdown_channel',
          'イベント通知',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('tousen'),
          color: Colors.white,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'カウントダウン終了通知',
      '$titleのカウントダウンが終了しました！',
      platformChannelSpecifics,
    );
  }

  void _passedEventProcess(Events event, BuildContext context) {
    if (!mounted) return;
    // showDialog(
    //   context: context,
    //   barrierColor: Colors.black54,
    //   builder: (context) => AlertDialog(
    //     title: const Text('おめでとうございます！'),
    //     content: Column(
    //       children: [
    //         SizedBox(height: 10),
    //         Text('ついに${event.title}の時が来ました！', style: TextStyle(fontSize: 25)),
    //         SizedBox(height: 20),
    //         Text(
    //           'イェーーーーーーーーーーーーーい！！！！！！！！！！！！',
    //           style: TextStyle(fontSize: 25),
    //         ),
    //       ],
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         child: const Text('OK', style: TextStyle(color: Colors.blue)),
    //       ),
    //     ],
    //   ),
    // );
    setState(() {
      Events.unsortedEventsList.remove(event);
      Events.eventsList.remove(event);
      _countdowns.remove(0);
    });
    saveEvents();
    _showPassedNotification(event.title);
    isDataLoaded = false;
    isLoaded().then((_) {
      setState(() {});
    });
  }

  Future<void> saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventListJson = Events.unsortedEventsList
        .map(
          (e) => jsonEncode({
            'title': e.title,
            'year': e.year,
            'month': e.month,
            'date': e.date,
            'hour': e.hour,
            'minute': e.minute,
          }),
        )
        .toList();
    await prefs.setStringList('events', eventListJson);
  }

  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventListJson = prefs.getStringList('events') ?? [];
    Events.unsortedEventsList = eventListJson.map((str) {
      final map = jsonDecode(str);
      return Events(
        title: map['title'],
        year: map['year'],
        month: map['month'],
        date: map['date'],
        hour: map['hour'],
        minute: map['minute'],
      );
    }).toList();
    Events.eventsList = List.from(
      Events.unsortedEventsList..sort((a, b) {
        final dateA = DateTime(a.year, a.month, a.date, a.hour, a.minute);
        final dateB = DateTime(b.year, b.month, b.date, b.hour, b.minute);
        return dateA.compareTo(dateB);
      }),
    );
  }

  bool isDataLoaded = false;
  Future<void> isLoaded() async {
    while (!isDataLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_countdowns[0] == null) {
        isDataLoaded = false;
      } else {
        isDataLoaded = true;
      }
    }
  }

  Widget loading() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Events.eventsList.isEmpty
          ? Center(
              child: Text(
                'No Events. Please add events in the Edit tab.',
                style: TextStyle(fontSize: 15),
              ),
            )
          : Column(
              children: [
                SizedBox(height: 40),
                Builder(
                  builder: (context) {
                    final firstEvent = Events.eventsList[0];
                    _doCountdown(
                      DateTime(
                        firstEvent.year,
                        firstEvent.month,
                        firstEvent.date,
                        firstEvent.hour,
                        firstEvent.minute,
                      ),
                    );
                    if (_countdowns[0] == Duration.zero) {
                      // _showPassedNotification(firstEvent.title);
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   _passedEventProcess(firstEvent, context);
                      // });
                      return Container(height: 0);
                      // return ElevatedButton(
                      //   onPressed: () {
                      //     _passedEventProcess(firstEvent, context);
                      //   },
                      //   child: Text('イベント処理'),
                      // );
                    }
                    final firstDiff = _countdowns[0] ?? Duration.zero;
                    return Container(
                      padding: const EdgeInsets.all(25),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.amber,
                          width: 10,
                        ), // 金色の枠
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isDataLoaded == false
                          ? loading()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  style: TextStyle(fontSize: 24),
                                  '${firstEvent.title}',
                                ),
                                Text(
                                  style: TextStyle(fontSize: 24),
                                  '${firstDiff.inDays}Days ${firstDiff.inHours % 24}h ${firstDiff.inMinutes % 60}m ${firstDiff.inSeconds % 60}s',
                                ),
                              ],
                            ),
                    );
                  },
                ),
                SizedBox(height: 40),
                Expanded(
                  child: isDataLoaded == false
                      ? loading()
                      : ListView.builder(
                          itemCount: Events.eventsList.length - 1,
                          itemBuilder: (context, index) {
                            final event = Events.eventsList[index + 1];
                            _doCountdown(
                              DateTime(
                                event.year,
                                event.month,
                                event.date,
                                event.hour,
                                event.minute,
                              ),
                            );
                            final diff =
                                _countdowns[index + 1] ?? Duration.zero;
                            return ListTile(
                              title: Text(
                                style: TextStyle(fontSize: 20),
                                '${event.title}まであと${diff.inDays}日${diff.inHours % 24}時間${diff.inMinutes % 60}分${diff.inSeconds % 60}秒',
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
