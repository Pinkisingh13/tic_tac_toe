
//Import necessary packages
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
     {

  // 2D List to represent the board 
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ""));
  bool isXTurn = true;// Tracks whose turn it is (X or O)
  String winner = ''; // Stores the winner ('X', 'O', 'Draw')
  int player1 = 0; // Player X score
  int player2 = 0; // Player O score
  List<int> winIndex = []; // Stores winning indices for highlighting


// Reset the game board and States
  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ""));

      isXTurn = true;
      winner = '';
      winIndex.clear();
    });
  }

// Handles user taps on the board
  void handleTap(int row, int column) async {
    if (board[row][column] == '' && winner == '') {

      //valid move
      setState(() {
        board[row][column] = isXTurn ? 'X' : 'O'; //update board with 'X' or 'O'
        isXTurn = !isXTurn; // switch player turn
        checkWinner(); // check for winner
        score(); // update score
      });
    } else {
      // Invalid Move

      HapticFeedback.vibrate(); // Provide haptic feedback

      // Show a SnackBar for invalid move
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


// Check for the winner
  void checkWinner() {
    winIndex.clear();
    for (var i = 0; i < 3; i++) {

      //rows
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        winIndex.addAll([i * 3, i * 3 + 1, i * 3 + 2]);
        winner = board[i][0];
        return;
      }
      //columns
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
      //diagonals
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

// Update the score based on the winner
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
                  isXTurn ? "X Turn!" : "O Turn!",
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
          // Game Board
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
                  int row = index ~/ 3; // determine row index
                  int column = index % 3; // determine column index
                  return GestureDetector(
                    onTap: () => handleTap(row, column), // handle user tap
                    child: NeonContainer(
                      lightBlurRadius: 10,
                      lightSpreadRadius: 1,
                      borderWidth: 5,
                      borderColor: Color.fromARGB(255, 132, 247, 255),
                      borderRadius: BorderRadius.circular(14),
                      containerColor: winIndex.contains(index) // Highlight winning cells
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

          // Display Scores for Player X and Player O
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