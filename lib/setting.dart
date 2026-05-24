// import 'package:flutter/material.dart';

// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   void set isEnglish(_) => true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           '設定',
//           style: TextStyle(fontSize: 30, color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: [
//                 SwitchListTile(
//                   title: const Text('English',style: TextStyle(fontSize: 20)),
//                   value: isEnglish,
//                   onChanged: (bool value) {
//                     setState(() {
//                       isEnglish = value;
//                     });
//                   },
//                   activeColor: Colors.blue,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
