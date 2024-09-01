import 'package:flutter/material.dart';
import 'bingo_cell.dart';

class BingoCellWidget extends StatelessWidget {
  final BingoCell cell;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const BingoCellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: cell.isChecked ? Colors.green[200] : Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(
            cell.goal,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
