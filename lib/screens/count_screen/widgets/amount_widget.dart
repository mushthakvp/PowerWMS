import 'package:flutter/material.dart';

class AmountWidget extends StatelessWidget {
  const AmountWidget(this.amount, {Key? key}) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FittedBox(
      fit: BoxFit.cover,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: theme.primaryColor,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        child: Center(
          child: Text(
            amount.toString(),
            style: theme.textTheme.headline4?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
