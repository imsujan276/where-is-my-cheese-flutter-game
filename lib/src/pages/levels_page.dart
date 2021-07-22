import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereIsMyCheese/src/data/data.dart';

import 'game_page.dart';

class LevelsPage extends StatefulWidget {
  LevelsPage({Key? key}) : super(key: key);

  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  int currentLevel = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();
    final int _currentLevel = prefs.getInt('currentLevel') ?? 1;
    setState(() {
      currentLevel = _currentLevel;
    });
  }

  reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentLevel', 1);
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.only(bottom: 15),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      margin: EdgeInsets.only(bottom: 15),
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text("Warning"),
                                    content: Text(
                                        "Are you sure you want to rest your progress?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        onPressed: () {
                                          reset();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Reset"),
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ),
                  ),
                ],
              ),
              Expanded(child: buildLevels(currentLevel)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLevels(int currentLevel) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 3 : 6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return index + 1 <= currentLevel
              ? buildAvailableLevel(index)
              : buildLockedLevel(index);
        },
      ),
    );
  }

  Widget buildAvailableLevel(int index) {
    return GestureDetector(
      onTap: () async {
        bool? isCompleted = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(index: index),
          ),
        );
        if (isCompleted != null && isCompleted) {
          init();
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridTile(
          child: Container(
            color: (index + 1 < currentLevel)
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : Colors.green.withOpacity(0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Level",
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLockedLevel(int index) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Do not be greedy.\n\nGet the CHEESE from Level $currentLevel to get here. "),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridTile(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.lock),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Level",
                        style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
