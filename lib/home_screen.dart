import 'package:flutter/material.dart';
import 'package:tic_tac/game_logic.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  int turn = 0;
  String result = '';
  bool gameOver = false;
  bool isSwitched = false;
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  children: [
                    ...firstBlock(),
                    SizedBox(height: 8),
                    expandTicToc(context),
                    ...endBlock(),
                  ],
                )
              : Row(children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstBlock(),
                        SizedBox(height: 20),
                        ...endBlock(),
                      ],
                    ),
                  ),
                  expandTicToc(context),
                ])),
    );
  }

  List<Widget> firstBlock() {
    return [
      SizedBox(height: 8),
      SwitchListTile.adaptive(
        title: Text(
          'Turn On/Off Two Player',
          style: TextStyle(color: Colors.white, fontSize: 25),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (newVal) {
          setState(() {
            isSwitched = newVal;
          });
        },
      ),
      Text(
        "It's $activePlayer Turn".toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 45),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> endBlock() {
    return [
      Text(
        result,
        style: TextStyle(color: Colors.white, fontSize: 40),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 8),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            turn = 0;
            result = '';
            gameOver = false;
          });
        },
        icon: Icon(Icons.replay),
        label: Text('Replay The Game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      ),
    ];
  }

  Expanded expandTicToc(BuildContext context) {
    return Expanded(
      child: GridView.count(
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        crossAxisCount: 3,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: gameOver ? null : () => _onTap(index),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).shadowColor),
              child: Center(
                  child: Text(
                Player.playerX.contains(index)
                    ? 'X'
                    : Player.playerO.contains(index)
                        ? 'O'
                        : '',
                style: TextStyle(
                  color: Player.playerX.contains(index)
                      ? Colors.blue
                      : Colors.pink,
                  fontSize: 45,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String theWinner = game.checkWinner();
      if (theWinner != '') {
        gameOver = true;
        result = '$theWinner is the Winner';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw';
      }
    });
  }
}
