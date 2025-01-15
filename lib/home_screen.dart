import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _scoreX = 0;
  int _scoreO = 0;
  bool _turnOfO = true;
  int _filledBoxes = 0;
  final List<String> _xOrOList = List.filled(9, '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearBoard,
          )
        ],
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          _buildPointsTable(),
          _buildGrid(),
          _buildTurn(),
        ],
      ),
    );
  }

  Widget _buildPointsTable() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPlayerScore('Player O', _scoreO),
          _buildPlayerScore('Player X', _scoreX),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String player, int score) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            player,
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            score.toString(),
            style: const TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => _tapped(index),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(
                child: Text(
                  _xOrOList[index],
                  style: TextStyle(
                    color: _xOrOList[index] == 'x' ? Colors.white : Colors.red,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTurn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          _turnOfO ? 'Turn of O' : 'Turn of X',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _tapped(int index) {
    if (_xOrOList[index] != '') return;

    setState(() {
      _xOrOList[index] = _turnOfO ? 'o' : 'x';
      _turnOfO = !_turnOfO;
      _filledBoxes++;
      _checkTheWinner();
    });
  }

  void _checkTheWinner() {
    final winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (_xOrOList[pattern[0]] == _xOrOList[pattern[1]] &&
          _xOrOList[pattern[1]] == _xOrOList[pattern[2]] &&
          _xOrOList[pattern[0]] != '') {
        _showAlertDialog('Winner', _xOrOList[pattern[0]]);
        return;
      }
    }

    if (_filledBoxes == 9) {
      _showAlertDialog('Draw', '');
    }
  }

  void _showAlertDialog(String title, String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(
          winner.isEmpty
              ? 'The match ended in a draw'
              : 'The winner is ${winner.toUpperCase()}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                if (winner == 'o') _scoreO++;
                if (winner == 'x') _scoreX++;
                _clearBoard();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        _xOrOList[i] = '';
      }
      _filledBoxes = 0;
    });
  }
}
