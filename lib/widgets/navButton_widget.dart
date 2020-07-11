import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  IconData icon;
  int index;
  int _currentIndex;

  NavButton(this.icon, this.index, this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width / 3 - 15,
      decoration: BoxDecoration(
        color: index == _currentIndex ? Colors.blueAccent : null,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          index == _currentIndex
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(
                  height: 15,
                ),
          index == _currentIndex
              ? Icon(
                  icon,
                  size: 25,
                  color: Colors.white,
                )
              : Icon(icon),
        ],
      ),
    );
  }
}
