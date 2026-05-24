import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'events.dart';
// import 'top.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  bool isEditing = false;
  String? errorText;

  void _addEvent(BuildContext context, int editIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? '編集' : 'Add Event'),
              content: SizedBox(
                height: 430,
                child: Column(
                  children: [
                    if (errorText != null) ...[
                      Row(
                        children: [
                          Text(
                            errorText ?? '',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.blue, // ← フォーカス時のラベルも青色
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: yearController,
                      decoration: InputDecoration(
                        labelText: 'year',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.blue, // ← フォーカス時のラベルも青色
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: monthController,
                      decoration: InputDecoration(
                        labelText: 'month',
                        // suffixIcon: const Padding(
                        //   padding: EdgeInsets.only(right: 300),
                        //   child: Text(
                        //     '*',
                        //     style: TextStyle(color: Colors.red, fontSize: 20),
                        //   ),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.blue, // ← フォーカス時のラベルも青色
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: dayController,
                      decoration: InputDecoration(
                        labelText: 'day',
                        // suffixIcon: const Padding(
                        //   padding: EdgeInsets.only(right: 200),
                        //   child: Text(
                        //     '*',
                        //     style: TextStyle(color: Colors.red, fontSize: 20),
                        //   ),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.blue, // ← フォーカス時のラベルも青色
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: hourController,
                      decoration: InputDecoration(
                        labelText: 'hour',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.blue, // ← フォーカス時のラベルも青色
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: minuteController,
                      decoration: InputDecoration(
                        labelText: 'minute',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.blue, // ← フォーカス時のラベルも青色
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      setState(() {
                        errorText = 'タイトルを入力してください';
                      });
                      return;
                    } else if (monthController.text.isEmpty) {
                      setState(() {
                        errorText = '月を入力してください';
                      });
                      return;
                    } else if (dayController.text.isEmpty) {
                      setState(() {
                        errorText = '日を入力してください';
                      });
                      return;
                    } else if (int.parse(monthController.text) > 12 ||
                        int.parse(monthController.text) < 1) {
                      setState(() {
                        errorText = 'エラーが出ました：月';
                      });
                      return;
                    } else if (int.parse(dayController.text) > 31 ||
                        int.parse(dayController.text) < 1) {
                      setState(() {
                        errorText = 'エラーが出ました：日';
                      });
                      return;
                    } else {
                      errorText = null;
                    }
                    final newEvent = Events(
                      title: titleController.text,
                      year:
                          int.tryParse(yearController.text) ??
                          DateTime.now().year,
                      month: int.parse(monthController.text),
                      date: int.parse(dayController.text),
                      hour:
                          int.tryParse(hourController.text) ?? 0, // ← 入力がなければ0
                      minute:
                          int.tryParse(minuteController.text) ??
                          0, // ← 入力がなければ0
                    );
                    if ((newEvent.hour >= 24 || newEvent.hour < 1) &&
                        newEvent.hour != 0) {
                      setState(() {
                        errorText = 'エラーが出ました：時';
                      });
                      return;
                    } else if ((newEvent.minute >= 60 || newEvent.minute < 1) &&
                        newEvent.minute != 0) {
                      setState(() {
                        errorText = 'エラーが出ました：分';
                      });
                      return;
                    } else if (DateTime(
                      newEvent.year,
                      newEvent.month,
                      newEvent.date,
                      newEvent.hour,
                      newEvent.minute,
                    ).isBefore(DateTime.now())) {
                      setState(() {
                        errorText = '記入した日は既に過ぎました';
                      });
                      return;
                    }
                    if (isEditing) {
                      Events.unsortedEventsList.remove(
                        Events.eventsList[editIndex],
                      );
                      Events.eventsList.removeAt(editIndex);
                    }
                    Events.unsortedEventsList.add(newEvent);
                    Events.eventsList = List.from(
                      Events.unsortedEventsList..sort((a, b) {
                        final dateA = DateTime(
                          a.year,
                          a.month,
                          a.date,
                          a.hour,
                          a.minute,
                        );
                        final dateB = DateTime(
                          b.year,
                          b.month,
                          b.date,
                          b.hour,
                          b.minute,
                        );
                        return dateA.compareTo(dateB);
                      }),
                    );
                    saveEvents();
                    Navigator.of(context).pop();
                    this.setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Events.eventsList.length,
              itemBuilder: (context, index) {
                final event = Events.eventsList[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(event.title, style: TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              isEditing = true;
                              titleController.text = event.title;
                              yearController.text = event.year.toString();
                              monthController.text = event.month.toString();
                              dayController.text = event.date.toString();
                              hourController.text = event.hour.toString();
                              minuteController.text = event.minute.toString();
                              errorText = null;
                              _addEvent(context, index);
                              // TopPageState().setState(() {});
                            },
                          ),
                          SizedBox(width: 15),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                Events.unsortedEventsList.remove(
                                  Events.eventsList[index],
                                );
                                Events.eventsList.removeAt(index);
                              });
                              saveEvents();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              isEditing = false;
              titleController.clear();
              yearController.clear();
              monthController.clear();
              dayController.clear();
              hourController.clear();
              minuteController.clear();
              errorText = null;
              _addEvent(context, 0);
              setState(() {});
              // TopPageState().setState(() {});
            },
            child: const Icon(Icons.add, size: 30, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
