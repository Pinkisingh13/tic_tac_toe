

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neon_widgets/neon_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ""));
  bool isXTurn = true;
  String winner = '';
  String playerName = 'X';
  int player1 = 0;
  int player2 = 0;
  List<int> winIndex = [];

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ""));

      isXTurn = true;
      winner = '';
      winIndex.clear();
    });
  }

  void handleTap(int row, int column) async {
    print(board);
    print("Clicked!!!");
    if (board[row][column] == '' && winner == '') {
      setState(() {
        board[row][column] = isXTurn ? 'X' : 'O';
        playerName = 'X';
        isXTurn = !isXTurn;
        checkWinner();
        score();
      });
    } else {
      print("vibration");

      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Invalid Move!",
          style: TextStyle(
              color: const Color.fromARGB(255, 157, 10, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 255, 188, 188),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void checkWinner() {
    winIndex.clear();
    for (var i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        winIndex.addAll([i * 3, i * 3 + 1, i * 3 + 2]);
        winner = board[i][0];
        return;
      }
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        winIndex.addAll([i, i + 3, i + 6]);
        winner = board[0][i];
        return;
      }
//diagonals
      if (board[0][0] != '' &&
          board[0][0] == board[1][1] &&
          board[1][1] == board[2][2]) {
        winIndex.addAll([0, 4, 8]);
        winner = board[0][0];
        return;
      }
      if (board[0][2] != '' &&
          board[0][2] == board[1][1] &&
          board[1][1] == board[2][0]) {
        winIndex.addAll([2, 4, 6]);
        winner = board[0][2];
        return;
      }

      //Draw
      if (winner == '' &&
          board.every((row) => row.every((cell) => cell != ''))) {
        winner = 'Draw';
      }
    }
  }

  void score() {
    if (winner == 'X') {
      setState(() {
        player1++;
      });
    } else if (winner == 'O') {
      setState(() {
        player2++;
      });
    } else {
      setState(() {
        player1 = player1;
        player2 = player2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 32, 88),
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontFamily: 'PressStart2P',
              color: Color(0xFFC9F9FC),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: resetGame,
            icon: Icon(
              Icons.refresh,
              color: Color(0xFFC9F9FC),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          winner.isEmpty
              ? Text(
                  isXTurn ? "$playerName Turn!" : "O Turn!",
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 32, 88),
                  ),
                )
              : Text(
                  winner == 'Draw' ? "It's a Draw!!" : "$winner Wins!",
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 32, 88),
                  ),
                ),
          SizedBox(height: 40),
          AspectRatio(
            aspectRatio: 0.80,
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 9,
                padding: EdgeInsets.only(left: 10, right: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int column = index % 3;
                  return GestureDetector(
                    onTap: () => handleTap(row, column),
                    child: NeonContainer(
                      lightBlurRadius: 10,
                      lightSpreadRadius: 1,
                      borderWidth: 5,
                      // lightSpreadRadius: 0,

                      borderColor: Color.fromARGB(255, 132, 247, 255),
                      borderRadius: BorderRadius.circular(14),
                      containerColor: winIndex.contains(index)
                          ? const Color.fromARGB(255, 0, 127, 4)
                          : Color.fromARGB(255, 0, 32, 88),

                      child: Center(
                        child: Text(
                          board[row][column],
                          style: TextStyle(
                              fontSize: 46,
                              color: Color(0XFFFCD015),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Player X: ",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 0, 32, 88),
                ),
              ),
              Text(
                "$player1",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFFCD015),
                ),
              ),
              SizedBox(width: 40),
              Text(
                "Player O: ",
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 0, 32, 88),
                ),
              ),
              Text(
                "$player2",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFFCD015),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
