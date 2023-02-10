import 'package:auto_size_text/auto_size_text.dart';
import 'package:delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:delivery_app/app/models/product_model.dart';
import 'package:delivery_app/app/pages/product_detail/product_detail_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDatailPage extends StatefulWidget {
  final ProductModel product;
  final OrderProductDto? orderProduct;

  const ProductDatailPage({
    Key? key,
    required this.product,
    this.orderProduct,
  }) : super(key: key);

  @override
  State<ProductDatailPage> createState() => _ProductDatailPageState();
}

class _ProductDatailPageState
    extends BaseState<ProductDatailPage, ProductDetailController> {
  @override
  void initState() {
    super.initState();
    final amount = widget.orderProduct?.amount ?? 1;
    controller.initial(amount, widget.orderProduct != null);
  }

  void _showConfirmDelete(int amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deseja excluir o produto'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: context.textStyles.textBold.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pop(
                OrderProductDto(
                  product: widget.product,
                  amount: amount,
                ),
              );
            },
            child: Text(
              'Confirmar',
              style: context.textStyles.textBold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            height: context.percentHeight(.4),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              widget.product.name,
              style: context.textStyles.textExtraBold.copyWith(fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Text(
                  widget.product.description,
                  style: context.textStyles.textMedium.copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Container(
                width: context.percentWidth(.5),
                height: 60,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return DeliveryIncrementDecrementButton(
                      amount: amount,
                      incrementTap: () => controller.increment(),
                      decrementTap: () => controller.decrement(),
                    );
                  },
                ),
              ),
              Container(
                width: context.percentWidth(.5),
                height: 60,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return ElevatedButton(
                      style: amount == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.red)
                          : null,
                      onPressed: () {
                        if (amount == 0) {
                          _showConfirmDelete(amount);
                        } else {
                          Navigator.of(context).pop(
                            OrderProductDto(
                              product: widget.product,
                              amount: amount,
                            ),
                          );
                        }
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text(
                          'Excluir produto',
                          style: context.textStyles.textExtraBold.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Adicionar',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                (widget.product.price * amount).currencyBR,
                                minFontSize: 5,
                                maxFontSize: 12,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                style:
                                    context.textStyles.textExtraBold.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
