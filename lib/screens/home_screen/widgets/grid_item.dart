import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String _title;
  final IconData _icon;
  final void Function()? onTap;

  const GridItem(this._title, this._icon, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Color(0xFFf7f7f9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              color: Color(0xFF0b4c82),
            ),
            SizedBox(
              height: 5,
            ),
            Text(_title),
          ],
        ),
      ),
    );
  }
}
