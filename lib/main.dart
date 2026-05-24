import 'package:flutter/material.dart';
import 'top.dart';
import 'edit.dart';
// import 'setting.dart';

void main() {
  runApp(const MyApp());
}

// 改善点リスト
// ⭕️アプリの名前
// ⭕️アイコン
// 通知
// アプリを閉じたままの通知
// ⭕️イベント経過後のshowDialogの編集
// ⭕️くるくる
// ⭕️画面を選択するとそのアイコンの下に青線
// 新規作成・編集後のtop画面の表示
// 編集画面のままでイベントが過ぎてもイベント経過時の動作（通知など）が可能
// 設定

// sita ue madeato sinnkisakusei

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown App',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color.fromARGB(255, 2, 113, 203),
      //   ),
      // ),
      home: const MyHomePage(title: 'カウントダウン　アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  // bool isEnglish = SettingPage().createState().isEnglish();

  static const List<Widget> _pages = <Widget>[
    TopPage(),
    EditPage(),
    // SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 0),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
          if (isSelected) SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 1,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.blue),
              ),
            ),
        ],
      ),
      label: '', // ラベルはカスタムで描画してるので空にする
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   backgroundColor: Colors.blue,
      //   title: Text(widget.title, style: TextStyle(fontSize: 30)),
      //   centerTitle: true,
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'トップ'),
          // BottomNavigationBarItem(icon: Icon(Icons.edit), label: '編集'),
          // BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
          _buildNavItem(Icons.home, 'Top', 0),
          _buildNavItem(Icons.edit, 'Edit', 1),
          // _buildNavItem(Icons.settings, '設定', 2),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
