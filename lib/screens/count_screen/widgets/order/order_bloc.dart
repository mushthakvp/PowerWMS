//
// class OrderBloc extends Cubit<OrderState> {
//   OrderBloc() : super(OrderInitialState());
//
//   onOrderTypeChange({required String orderTypeCode}) {
//     emit(state.copyWith(orderTypeCode: orderTypeCode));
//   }
//
//   onCustomerChange({required String customerCode}) {
//     emit(state.copyWith(customerCode: customerCode));
//   }
//
//   onSubmitted() {
//     emit(OrderSubmittedState(
//         orderTypeCode: state.orderTypeCode,
//         customerCode: state.customerCode)
//     );
//   }
// }
//
// class OrderState {
//   OrderState({
//     required this.orderTypeCode,
//     required this.customerCode,
//   });
//   final String? orderTypeCode;
//   final String? customerCode;
//
//   bool get validate {
//     return orderTypeCode != null &&
//         orderTypeCode!.trim().isNotEmpty &&
//         customerCode != null &&
//         customerCode!.trim().isNotEmpty;
//   }
//
//   OrderState copyWith({
//     String? orderTypeCode,
//     String? customerCode,
//   }) {
//     return OrderState(
//       orderTypeCode: orderTypeCode ?? this.orderTypeCode,
//       customerCode: customerCode ?? this.customerCode,
//     );
//   }
// }
//
// class OrderInitialState extends OrderState {
//   OrderInitialState() : super(orderTypeCode: null, customerCode: null);
// }
//
// class OrderSubmittedState extends OrderState {
//   OrderSubmittedState({
//     required super.orderTypeCode,
//     required super.customerCode
//   });
// }