import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:flutter/material.dart';

class OrderCompletedPage extends StatefulWidget {
  const OrderCompletedPage({super.key});

  @override
  State<OrderCompletedPage> createState() => _OrderCompletedPageState();
}

class _OrderCompletedPageState extends State<OrderCompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: context.percentHeight(.2),
              ),
              Image.asset(
                'assets/images/logo_rounded.png',
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Pedido realizado com sucesso, em breve você recebera a confirmação do pedido',
                textAlign: TextAlign.center,
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DeliveryButton(
                width: context.percentWidth(.8),
                label: 'Fechar',
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
