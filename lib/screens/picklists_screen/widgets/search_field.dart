import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:scanner/widgets/e_textfield.dart';

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
  bool willShowKeyboard = false;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController
        .onChange
        .listen((bool visible) {
      setState(() {
        willShowKeyboard = visible;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (widget.value != widget.controller.text) {
      widget.controller.text = widget.value;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ETextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        onChanged: _onChangeHandler,
        onTap: () {
          SystemChannels.textInput.invokeMethod<void>('TextInput.show');
        },
        autofocus: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.picklistsSearch,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: widget.controller.text.isEmpty ? _keyboardButton() : IconButton(
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

  _keyboardButton() {
    return IconButton(
      hoverColor: Colors.white,
      splashColor: Colors.white,
      highlightColor: Colors.white,
      icon: Icon(
          !willShowKeyboard ? Icons.keyboard_alt_outlined : Icons.keyboard_alt_rounded
      ),
      onPressed: () async {
        if (willShowKeyboard) {
          SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
        } else {
          SystemChannels.textInput.invokeMethod<void>('TextInput.show');
        }
        setState(() {
          willShowKeyboard = !willShowKeyboard;
        });
      },
    );
  }
}
