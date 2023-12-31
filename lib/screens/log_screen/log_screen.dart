// import 'package:flutter/material.dart';
// import 'package:scanner/log.dart';
// import 'package:scanner/screens/log_screen/widgets/log_tile.dart';
// import 'package:scanner/widgets/wms_app_bar.dart';
//
// class LogScreen extends StatelessWidget {
//   static const routeName = '/logs';
//
//   const LogScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: WMSAppBar(
//         'Logs',
//       ),
//       body: FutureBuilder(
//         future: logger,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData) {
//             if (snapshot.data!.length == 0) {
//               return Container(
//                 child: Text('No logs.'),
//                 padding: EdgeInsets.all(20),
//                 alignment: Alignment.center,
//               );
//             }
//             return ListView.separated(
//               itemBuilder: (context, i) {
//                 return LogTile(snapshot.data![i]);
//               },
//               separatorBuilder: (_, i) => Divider(),
//               itemCount: snapshot.data!.length,
//             );
//           }
//           if (snapshot.hasError) {
//             return Text(snapshot.error.toString());
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }
