import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'bingo_cell.dart';

class BingoBoard extends StatefulWidget {
  const BingoBoard({super.key});

  @override
  State<BingoBoard> createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  List<List<BingoCell>> _board = [];

  @override
  void initState() {
    super.initState();
    _loadBoard();
  }

  Future<void> _loadBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final String? boardJson = prefs.getString('bingo_board');
    if (boardJson != null) {
      final List<dynamic> decodedBoard = json.decode(boardJson);
      setState(() {
        _board = decodedBoard.map((row) {
          return (row as List<dynamic>)
              .map((cell) => BingoCell.fromJson(cell as Map<String, dynamic>))
              .toList();
        }).toList();
      });
    } else {
      setState(() {
        _board = List.generate(
            5,
            (_) =>
                List.generate(5, (_) => BingoCell(goal: '', isChecked: false)));
      });
    }
  }

  Future<void> _saveBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final String boardJson = json.encode(_board
        .map((row) => row
            .map((cell) => {'goal': cell.goal, 'isChecked': cell.isChecked})
            .toList())
        .toList());
    await prefs.setString('bingo_board', boardJson);
  }

  @override
  Widget build(BuildContext context) {
    if (_board.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 25,
      itemBuilder: (context, index) {
        final row = index ~/ 5;
        final col = index % 5;
        return BingoCellWidget(
          cell: _board[row][col],
          onTap: () => _board[row][col].goal.isEmpty
              ? _editCell(row, col)
              : _toggleCheck(row, col),
          onLongPress: () => _editCell(row, col),
        );
      },
    );
  }

  void _toggleCheck(int row, int col) {
    setState(() {
      _board[row][col].isChecked = !_board[row][col].isChecked;
      _saveBoard();
    });
  }

  void _editCell(int row, int col) {
    final TextEditingController controller =
        TextEditingController(text: _board[row][col].goal);
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = _board[row][col].goal;
        return AlertDialog(
          title: const Text('目標を入力'),
          content: TextField(
            onChanged: (value) {
              newGoal = value;
            },
            controller: controller,
            decoration: const InputDecoration(hintText: "目標を入力してください"),
          ),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () {
                setState(() {
                  _board[row][col].goal = newGoal;
                  _saveBoard();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
