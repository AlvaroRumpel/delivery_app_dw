import 'dart:developer';

import 'package:delivery_app/app/dto/order_dto.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/pages/order/order_state.dart';
import 'package:delivery_app/app/repositories/order/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(const OrderState.initial());

  Future<void> load(List<OrderProductDto> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));
      final payment = await _orderRepository.getAllPaymentsTypes();
      emit(
        state.copyWith(
          status: OrderStatus.loaded,
          orderProducts: products,
          paymentsType: payment,
        ),
      );
    } catch (e, s) {
      log('Erro ao buscar metodos de pagamentos', error: e, stackTrace: s);
      emit(
        state.copyWith(
            status: OrderStatus.error,
            errorMessage: 'Erro ao buscar metodos de pagamentos'),
      );
    }
  }

  void incrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];

    orders[index] = order.copyWith(amount: order.amount + 1);
    emit(
      state.copyWith(
        orderProducts: orders,
        status: OrderStatus.updateOrder,
      ),
    );
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(
          OrderConfirmDeleteProductState(
            index: index,
            orderProduct: order,
            status: OrderStatus.confirmRemoveProduct,
            orderProducts: state.orderProducts,
            paymentsType: state.paymentsType,
            errorMessage: state.errorMessage,
          ),
        );
        return;
      }
      orders.removeAt(index);
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    }

    emit(
      state.copyWith(
        orderProducts: orders,
        status: OrderStatus.updateOrder,
      ),
    );
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  Future<void> saveOrder(
      {required String address,
      required String document,
      required int paymentMethodId}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await _orderRepository.saveOrder(
        OrderDto(
          products: state.orderProducts,
          address: address,
          document: document,
          paymentMethodId: paymentMethodId,
        ),
      );
      emit(state.copyWith(status: OrderStatus.success));
    } catch (e) {}
  }
}
