import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maze/maze.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereIsMyCheese/src/data/data.dart';
import 'package:whereIsMyCheese/src/models/levels.dart';

class GamePage extends StatefulWidget {
  final int index;
  GamePage({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int reachedCheckpoints = 0;
  bool isCompleted = false;
  late Level level;

  @override
  void initState() {
    super.initState();
    level = data[widget.index];
  }

  setActiveLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final int currentLevel = prefs.getInt('currentLevel') ?? 1;
    if (level < currentLevel) return;
    prefs.setInt('currentLevel', level + 1);
  }

  playAgain(int index) {
    setState(() {
      level = data[index];
    });
    print(level);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  margin: EdgeInsets.all(16),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          isCompleted,
                        );
                      }),
                ),
                Text(
                  "Maze ${level.level}",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            Expanded(
              child: Maze(
                player: MazeItem('assets/rat.png', ImageType.asset),
                columns: level.row,
                rows: level.column,
                wallThickness: 2.0,
                wallColor: Theme.of(context).primaryColor,
                finish: MazeItem('assets/cheese.png', ImageType.asset),
                checkpoints: level.checkpoints,
                onFinish: () {
                  if (level.checkpoints.length == reachedCheckpoints) {
                    setState(() {
                      isCompleted = true;
                    });
                    setActiveLevel(level.level);
                    HapticFeedback.vibrate();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("Yummmm!!! 😍"),
                            content: Text("That was delicious... 🤤"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                },
                                child: Text("Get More Cheese"),
                              ),
                            ],
                          );
                        });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Collect all foods before the DELICIOUS CHEESE. It is your desert'),
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                onCheckpoint: (checkointIndex) {
                  setState(() {
                    reachedCheckpoints += 1;
                  });
                  HapticFeedback.vibrate();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Delicious!!!! 😍'),
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
                height: size.height - 50,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
