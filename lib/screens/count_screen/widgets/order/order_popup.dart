// import 'package:brouwer/generated/l10n.dart';
// import 'package:brouwer/screens/home_screen/widgets/order/order_bloc.dart';
// import 'package:brouwer/utils/assets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// typedef OnSubmitOrder = Function(String orderTypeCode, String customerCode);
//
// Future<void> showOrderPopup({
//     required BuildContext context,
//     required OnSubmitOrder onSubmitOrder}
// ) async {
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(16),
//           content: OrderPopup.instance(
//               onSubmitOrder: onSubmitOrder
//           ),
//         );
//       }
//   );
// }
//
// class OrderPopup extends StatefulWidget {
//   const OrderPopup._({required this.onSubmitOrder, Key? key}) : super(key: key);
//
//   static Widget instance({required OnSubmitOrder onSubmitOrder}) {
//     return BlocProvider(
//         create: (_) => OrderBloc(),
//       child: OrderPopup._(
//           onSubmitOrder: onSubmitOrder
//       ),
//     );
//   }
//   final OnSubmitOrder onSubmitOrder;
//   @override
//   State<OrderPopup> createState() => _OrderPopupState();
// }
//
// class _OrderPopupState extends State<OrderPopup> {
//
//   late TextEditingController orderTypeEditingController = TextEditingController(text: '');
//   late TextEditingController customerEditingController = TextEditingController(text: '');
//   late OrderBloc _orderBloc;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _orderBloc = BlocProvider.of<OrderBloc>(context, listen: false);
//     });
//   }
//
//   _dismissPopup() {
//     if (!mounted) return;
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final intl = S.of(context);
//     return BlocListener<OrderBloc, OrderState>(
//       listener: (context, state) {
//         if (state is OrderSubmittedState) {
//           widget.onSubmitOrder(state.orderTypeCode!, state.customerCode!);
//           _dismissPopup();
//         }
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//               alignment: Alignment.centerRight,
//               child: SizedBox(
//                 width: 32,
//                 child: InkWell(
//                   onTap: () {
//                     _dismissPopup();
//                   },
//                   child: const Icon(AppAssets.icClose),
//                 ),
//               )
//           ),
//           Column(
//             children: <Widget>[
//               BlocBuilder<OrderBloc, OrderState>(
//                 builder: (context, state) {
//                   return TextFormField(
//                     controller: orderTypeEditingController,
//                     autofocus: true,
//                     onChanged: (String val) {
//                       _orderBloc.onOrderTypeChange(orderTypeCode: val);
//                     },
//                     decoration: InputDecoration(
//                       labelText: S.of(context).orderType,
//                       suffixIcon: IconButton(
//                         onPressed: () async {
//                           await _startParseOrderType(intl);
//                         },
//                         icon: const Icon(AppAssets.icCamera),
//                       ),
//                     ),
//                   );
//                 },
//                 buildWhen: (p, c) => p.orderTypeCode != c.orderTypeCode,
//               ),
//               const SizedBox(height: 16),
//               BlocBuilder<OrderBloc, OrderState>(
//                 builder: (context, state) {
//                   return TextFormField(
//                     controller: customerEditingController,
//                     onChanged: (String val) {
//                       _orderBloc.onCustomerChange(customerCode: val);
//                     },
//                     decoration: InputDecoration(
//                       labelText: S.of(context).customer,
//                       suffixIcon: IconButton(
//                         onPressed: () async {
//                           await _startParseCustomer(intl);
//                         },
//                         icon: const Icon(AppAssets.icCamera),
//                       ),
//                     ),
//                   );
//                 },
//                 buildWhen: (p, c) => p.customerCode != c.customerCode,
//               ),
//               const SizedBox(height: 20),
//               BlocSelector<OrderBloc, OrderState, bool>(
//                   selector: (state) => state.validate,
//                   builder: (context, validate) {
//                     return SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: !validate ? null : () async {
//                           _orderBloc.onSubmitted();
//                         },
//                         child: Text(S.of(context).confirm.toUpperCase()),
//                       ),
//                     );
//                   })
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Future<void> _startParseOrderType(S intl) async {
//     String barcode = await FlutterBarcodeScanner.scanBarcode(
//       "#ff6666",
//       intl.complete,
//       true,
//       ScanMode.DEFAULT,
//     );
//     orderTypeEditingController.text = barcode;
//     _orderBloc.onOrderTypeChange(orderTypeCode: barcode);
//   }
//
//   Future<void> _startParseCustomer(S intl) async {
//     String barcode = await FlutterBarcodeScanner.scanBarcode(
//       "#ff6666",
//       intl.complete,
//       true,
//       ScanMode.DEFAULT,
//     );
//     customerEditingController.text = barcode;
//     _orderBloc.onCustomerChange(customerCode: barcode);
//   }
// }
