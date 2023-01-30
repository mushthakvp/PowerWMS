import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import 'package:scanner/widgets/text_field_outlined.dart';

class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({
    Key? key,
    required this.title,
     this.inputFormatters,
    this.hint,
    this.controller,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.maxLine,
    this.prefix,
    this.isEnabled,
    this.keyboard,
    this.textInputAction,
  }) : super(key: key);
  final List<TextInputFormatter>? inputFormatters;
  final String title;
  final String? hint;
  final bool? isEnabled;
  final int? maxLine;
  final Widget? prefix;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title :",
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.lightGrey
              .s14,
        ),
        Gap(12),
        CustomTextField(
          inputFormatters: inputFormatters,
          isEnabled: isEnabled,
          initialValue: initialValue,
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLine,
          prefix: prefix,
          validator: validator,
          hint: hint ?? "",
          hintStyle: TextStyle(color: Color(0xFF000000).withOpacity(0.4)).s14,
          height: 11,
          borderColor: Color(0xFFCCCCCC),
          keyboard: keyboard,
          textInputAction: textInputAction,
        ),
        Gap(16),
      ],
    );
  }
}
