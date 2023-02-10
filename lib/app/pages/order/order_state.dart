import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/models/payment_type_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  initial,
  loaded,
  loading,
  error,
  updateOrder,
  confirmRemoveProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> orderProducts;
  final List<PaymentTypeModel> paymentsType;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.orderProducts,
    required this.paymentsType,
    this.errorMessage,
  });

  const OrderState.initial()
      : status = OrderStatus.initial,
        orderProducts = const [],
        paymentsType = const [],
        errorMessage = null;

  double get totalOrder => orderProducts.fold(
        0,
        (previousValue, element) => previousValue + element.totalPrice,
      );

  @override
  List<Object?> get props =>
      [status, orderProducts, paymentsType, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? orderProducts,
    List<PaymentTypeModel>? paymentsType,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProducts: orderProducts ?? this.orderProducts,
      paymentsType: paymentsType ?? this.paymentsType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.status,
    required super.orderProducts,
    required super.paymentsType,
    super.errorMessage,
  });
}
