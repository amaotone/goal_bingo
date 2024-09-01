import 'package:flutter/material.dart';

class BingoBoard extends StatefulWidget {
  const BingoBoard({Key? key}) : super(key: key);

  @override
  _BingoBoardState createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  final List<List<String>> _board = List.generate(
    5,
    (_) => List.generate(5, (_) => ''),
  );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: 25,
      itemBuilder: (context, index) {
        int row = index ~/ 5;
        int col = index % 5;
        return GestureDetector(
          onTap: () => _toggleCell(row, col),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: _board[row][col].isNotEmpty ? Colors.yellow : Colors.white,
            ),
            child: Center(
              child: Text(
                _board[row][col],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleCell(int row, int col) {
    setState(() {
      if (_board[row][col].isEmpty) {
        _board[row][col] = 'X';
      } else {
        _board[row][col] = '';
      }
    });
  }
}
