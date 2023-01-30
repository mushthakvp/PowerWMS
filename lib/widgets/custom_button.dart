import 'package:flutter/material.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.title,
    this.width = 100,
    this.height = 48,
    this.onPressed,
    this.isBusy = false,
    this.child,
    this.radius = 45,
    this.buttonColor,
    this.textColor,
    this.border,
    this.textStyle,
  })  : assert((child == null && title != null) || (child != null)),
        super(key: key);
  final String? title;
  final double width;
  final double radius;
  final double height;
  final void Function()? onPressed;
  final bool isBusy;
  final Widget? child;
  final Color? buttonColor;
  final TextStyle? textStyle;
  final Color? textColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isBusy ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(radius),
          border: border,
        ),
        alignment: Alignment.center,
        child: isBusy
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : child ??
                Text(
                  title!,
                  style: textStyle ??
                      Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(color: textColor ?? Colors.white)
                          .bold
                          .s18,
                ),
      ),
    );
  }
}
