import 'package:flutter/material.dart';
import 'package:whereIsMyCheese/src/pages/levels_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        // image: DecorationImage(
        //     image: AssetImage("assets/background.jpg"), fit: BoxFit.fill)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   'Where is my \nCheese ?',
            //   style: TextStyle(fontSize: 30, color: Colors.white),
            // ),
            Spacer(),
            TopImage(),
            SizedBox(
              height: 30,
            ),
            PlayButton(),
            SizedBox(
              height: 10,
            ),

            SizedBox(height: 40),
            LeaderboardWidget(),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}

class TopImage extends StatefulWidget {
  const TopImage({
    Key? key,
  }) : super(key: key);

  @override
  _TopImageState createState() => _TopImageState();
}

class _TopImageState extends State<TopImage>
    with SingleTickerProviderStateMixin {
  double distance = 30;

  ///defining animation
  late Animation<double> animation;
  late AnimationController controller;
  double width = 200;
  bool _visibility = false;

  double posX = 0;
  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _visibility = true;
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      // _visibility = true;
      setState(() {
        posX++;
      });
      print(posX);
      isEating();
    });
    controller.forward();

    super.initState();
  }

  isEating() {
    if (posX == (width - 80)) {
      controller.stop();
      //Timer(Duration(seconds:4,(){});
      setState(() {
        _visibility = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          AnimatedOpacity(
              opacity: _visibility ? 0 : 1,
              duration: const Duration(seconds: 5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Where is my cheese ?',
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [Mouse(), Cheese()],
                    // )
                  ],
                ),
              )),
          Positioned(
              left: posX,
              top: 0,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _visibility = true;
                      posX = 0;
                    });
                    controller.repeat();
                  },
                  child: Mouse())),
          Positioned(
              left: width,
              top: 0,
              child: Visibility(visible: _visibility, child: Cheese())),
        ],
      ),
    );
  }
}

class Mouse extends StatelessWidget {
  const Mouse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/rat.png',
      height: 100,
      width: 100,
    );
  }
}

class Cheese extends StatelessWidget {
  const Cheese({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/cheese.png',
      height: 50,
      width: 50,
    );
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
  }) : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController motionController;
  double size = 40;
  @override
  void initState() {
    motionController = AnimationController(
        duration: Duration(seconds: 1), vsync: this, lowerBound: .8);
    motionController.forward();
    motionController.addListener(() {
      setState(() {
        size = motionController.value * 40;
      });
    });
    motionController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        motionController.reverse();
      else if (status == AnimationStatus.dismissed) motionController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelsPage(),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
        ),
        child: Container(
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.orange.shade400.withOpacity(size / 40),
            child: Icon(
              Icons.play_circle_fill_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        // CircleAvatar(
        //   radius: 25,
        //   backgroundColor: Colors.deepOrange.shade600,
        //   child: CircleAvatar(
        //       backgroundColor: Colors.orange,
        //       child: Icon(
        //         Icons.flag,
        //         color: Colors.white,
        //       )),
        // ),
        // SizedBox(width: 20),
        // CircleAvatar(
        //   radius: 25,
        //   backgroundColor: Colors.deepOrange.shade600,
        //   child: CircleAvatar(
        //       backgroundColor: Colors.orange,
        //       child: Icon(
        //         Icons.leaderboard_outlined,
        //         color: Colors.white,
        //       )),
        // ),
        // SizedBox(width: 20),
        // CircleAvatar(
        //   radius: 25,
        //   backgroundColor: Colors.deepOrange.shade600,
        //   child: CircleAvatar(
        //       backgroundColor: Colors.orange,
        //       child: Icon(
        //         Icons.shopping_cart_rounded,
        //         color: Colors.white,
        //       )),
        // ),
        Spacer(),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(30)),
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
