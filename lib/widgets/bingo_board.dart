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
  List<List<List<BingoCell>>> _boards = [];
  int _currentBoardIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBoards();
  }

  Future<void> _loadBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? boardsJson = prefs.getString('bingo_boards');
    if (boardsJson != null) {
      final List<dynamic> decodedBoards = json.decode(boardsJson);
      setState(() {
        _boards = decodedBoards.map((board) {
          return (board as List<dynamic>).map((row) {
            return (row as List<dynamic>)
                .map((cell) => BingoCell.fromJson(cell as Map<String, dynamic>))
                .toList();
          }).toList();
        }).toList();
      });
    } else {
      setState(() {
        _boards = [_createEmptyBoard()];
      });
    }
  }

  List<List<BingoCell>> _createEmptyBoard() {
    return List.generate(5,
        (_) => List.generate(5, (_) => BingoCell(goal: '', isChecked: false)));
  }

  Future<void> _saveBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final String boardsJson = json.encode(_boards
        .map((board) => board
            .map((row) => row
                .map((cell) => {'goal': cell.goal, 'isChecked': cell.isChecked})
                .toList())
            .toList())
        .toList());
    await prefs.setString('bingo_boards', boardsJson);
  }

  void _addNewBoard() {
    setState(() {
      _boards.add(_createEmptyBoard());
      _currentBoardIndex = _boards.length - 1;
      _saveBoards();
    });
  }

  void _toggleCheck(int row, int col) {
    setState(() {
      _boards[_currentBoardIndex][row][col].isChecked =
          !_boards[_currentBoardIndex][row][col].isChecked;
      _saveBoards();
    });
  }

  void _editCell(int row, int col) {
    final TextEditingController controller =
        TextEditingController(text: _boards[_currentBoardIndex][row][col].goal);
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = _boards[_currentBoardIndex][row][col].goal;
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
                  _boards[_currentBoardIndex][row][col].goal = newGoal;
                  _saveBoards();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBingoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
          cell: _boards[_currentBoardIndex][row][col],
          onTap: () => _boards[_currentBoardIndex][row][col].goal.isEmpty
              ? _editCell(row, col)
              : _toggleCheck(row, col),
          onLongPress: () => _editCell(row, col),
        );
      },
    );
  }

  Widget _buildBoardList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('ビンゴカード ${index + 1}'),
          selected: index == _currentBoardIndex,
          onTap: () {
            setState(() {
              _currentBoardIndex = index;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_boards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBingoGrid(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _addNewBoard,
                    child: const Text('新しいビンゴカードを追加'),
                  ),
                ),
                _buildBoardList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
