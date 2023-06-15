import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<String> board;
  String currentPlayer='';
  String winner='';
  List<GameResult> gameResults = [];
  TextEditingController player1Controller = TextEditingController();
  TextEditingController player2Controller = TextEditingController();

  _TicTacToeScreenState() {
    board = List<String>.generate(9, (index) => '');
    currentPlayer = 'X';
    winner = '';
  }

  void resetBoard() {
    setState(() {
      board = List<String>.generate(9, (index) => '');
      currentPlayer = 'X';
      winner = '';
    });
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        checkWinner();
      });
    }
  }

  void checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var combination in winningCombinations) {
      int a = combination[0];
      int b = combination[1];
      int c = combination[2];

      if (board[a] != '' && board[a] == board[b] && board[a] == board[c]) {
        setState(() {
          winner = board[a];
          gameResults.add(GameResult(gameResults.length + 1, player1Controller.text, player2Controller.text, winner));
        });
        break;
      }
    }

    if (!board.contains('') && winner == '') {
      setState(() {
        winner = 'Draw';
        gameResults.add(GameResult(gameResults.length + 1, player1Controller.text, player2Controller.text, winner));
      });
    }
  }

  Widget buildBoardButton(int index) {
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;

    if (board[index] == 'X') {
      textColor = Colors.blue;
    } else if (board[index] == 'O') {
      textColor = Colors.red;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => makeMove(index),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              board[index],
              style: TextStyle(
                fontSize: 24.0,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        color: Color.fromARGB(255, 139, 211, 244), // Fondo de color celeste
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: player1Controller,
                      decoration: InputDecoration(
                        labelText: 'Player 1 ( X )',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: player2Controller,
                      decoration: InputDecoration(
                        labelText: 'Player 2 ( O )',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(16.0),
                childAspectRatio: 1.5,
                children: List.generate(9, (index) => buildBoardButton(index)),
              ),
            ),
            if (winner.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  (winner == 'Draw') ? 'It\'s a draw!' : 'Player $winner wins!',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ElevatedButton(
              onPressed: resetBoard,
              child: Text('Reset'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Game Results',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Player 1')),
                    DataColumn(label: Text('Player 2')),
                    DataColumn(label: Text('Winner')),
                  ],
                  rows: gameResults.map((result) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(result.id.toString())),
                        DataCell(Text(result.player1)),
                        DataCell(Text(result.player2)),
                        DataCell(Text(result.winner)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameResult {
  final int id;
  final String player1;
  final String player2;
  final String winner;

  GameResult(this.id, this.player1, this.player2, this.winner);
}
