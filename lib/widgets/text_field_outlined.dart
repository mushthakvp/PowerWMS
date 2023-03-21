import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.controller,
    this.color,
    this.textStyle,
    this.hintStyle,
    this.icon,
    this.initialValue,
     this.inputFormatters,
    this.maxLength,
    this.keyboard,
    this.scrollPadding,
    this.maxLines,
    this.obscure,
    this.borderColor,
    this.borderRadius,
    this.contentPadding,
    this.isFilled = false,
    this.onSubmitted,
    this.suffix,
    this.prefix,
    this.hint,
    this.validator,
    this.isEnabled,
    this.height,
    this.label,
    this.onChanged,
    this.isUnderLine = false,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.minLines,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? initialValue;
  final Widget? label;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? icon;
  final List<TextInputFormatter>? inputFormatters;
  final Color? color;
  final GestureTapCallback? onTap;
  final TextStyle? textStyle;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextStyle? hintStyle;
  final int? maxLength;
  final bool? isEnabled;
  final bool? obscure;
  final bool isUnderLine;
  final bool isFilled;
  final double? height;
  final double? borderRadius;
  final Color? borderColor;
  final EdgeInsets? scrollPadding;
  final EdgeInsets? contentPadding;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      scrollPadding: scrollPadding ?? EdgeInsets.all(20),
      initialValue: initialValue,
      onTap: onTap,
      focusNode: focusNode,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: textStyle,
      textAlign: TextAlign.start,
      enabled: isEnabled ?? true,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboard,
      obscureText: obscure ?? false,
      decoration: InputDecoration(
        hintText: hint,
        icon: icon,
        hintStyle: hintStyle,
        alignLabelWithHint: true,
        suffixIcon: suffix,
        prefixIcon: prefix,
        counterText: "",
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(vertical: height ?? 20, horizontal: 16),
        isDense: true,
        isCollapsed: true,
        fillColor: color /*?? kScaffoldColor*/,
        filled: isFilled,
        label: label,
        labelStyle: hintStyle,
        enabledBorder: isUnderLine
            ? UnderlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Color(0x40000000)))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: borderColor == null
                    ? BorderSide.none
                    : Border.all(color: borderColor!).right),
        focusedBorder: isUnderLine
            ? UnderlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Color(0x40000000)))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide:
                    Border.all(color: Theme.of(context).primaryColor).right),
        border: isUnderLine
            ? UnderlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Color(0x40000000)))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: borderColor == null
                    ? BorderSide.none
                    : Border.all(color: borderColor!).right),
      ),
    );
  }
}
