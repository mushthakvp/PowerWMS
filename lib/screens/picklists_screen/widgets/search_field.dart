import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchField extends StatefulWidget {
  const SearchField(this.value, this.onChange, {Key? key}) : super(key: key);

  final String value;
  final void Function(String value) onChange;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? searchOnStoppedTyping;
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    if (widget.value != controller.text) {
      controller.text = widget.value;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        onChanged: _onChangeHandler,
        autofocus: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.picklistsSearch,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  _onChangeHandler(String value) {
    const duration = Duration(milliseconds: 700);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    searchOnStoppedTyping = new Timer(duration, () => widget.onChange(value));
  }
}
