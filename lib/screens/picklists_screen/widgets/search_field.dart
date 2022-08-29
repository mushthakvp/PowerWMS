import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchField extends StatefulWidget {
  const SearchField(
      this.value,
      this.onChange,
      this.controller,
      this.focusNode,
      {Key? key}) : super(key: key);

  final String value;
  final void Function(String value) onChange;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? searchOnStoppedTyping;
  bool willShowKeyboard = true;

  @override
  void didChangeDependencies() {
    if (widget.value != widget.controller.text) {
      widget.controller.text = widget.value;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        onChanged: _onChangeHandler,
        autofocus: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.picklistsSearch,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: widget.controller.text.isEmpty ? _toggleKeyboard() : IconButton(
              hoverColor: Colors.white,
              splashColor: Colors.white,
              highlightColor: Colors.white,
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.controller.clear();
                _onChangeHandler('');
              },
          ), // Show the clear button if the text field has something
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

  _toggleKeyboard() {
    return Container(
      child: IconButton(
        hoverColor: Colors.white,
        splashColor: Colors.white,
        highlightColor: Colors.white,
        icon: Icon(
            !willShowKeyboard ? Icons.keyboard_alt_outlined : Icons.keyboard_alt_rounded
        ),
        onPressed: () {
          if (willShowKeyboard) {
            FocusScope.of(context).unfocus();
          } else {
            widget.focusNode.requestFocus();
          }
          setState(() {
            willShowKeyboard = !willShowKeyboard;
          });
        },
      ),
    );
  }
}
