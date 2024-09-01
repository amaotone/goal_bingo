import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BingoCell {
  String goal;
  bool isChecked;

  BingoCell({required this.goal, required this.isChecked});

  factory BingoCell.fromJson(Map<String, dynamic> json) {
    return BingoCell(
      goal: json['goal'] as String,
      isChecked: json['isChecked'] as bool,
    );
  }
}

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
        child: Padding(
          padding: const EdgeInsets.all(2.0), // ここで隙間を設ける
          child: Center(
            child: AutoSizeText(
              cell.goal,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 5, // 最大行数を設定
              minFontSize: 10, // 最小フォントサイズを設定
              overflow: TextOverflow.visible, // 溢れた場合の処理をvisibleに設定
            ),
          ),
        ),
      ),
    );
  }
}
