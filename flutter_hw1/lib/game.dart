import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

import 'character_selection.dart';

class JumpGame extends StatefulWidget {
  final String character;
  final double characterHeight;
  final double characterWidth;

  const JumpGame({
    required this.character,
    required this.characterHeight,
    required this.characterWidth,
    super.key,
  });

  @override
  JumpGameState createState() => JumpGameState();
}

class JumpGameState extends State<JumpGame> {
  double characterY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool gameHasStarted = false;
  double obstacleX = 1;
  bool gameOver = false;
  double obstacleHeight = 200;
  double gapHeight = 150;
  int score = 0;
  int bestScore = 0;
  final AudioCache _audioCache = AudioCache(prefix: 'assets/sounds/');

  void jump() {
    if (!gameOver) {
      _audioCache.play('jump.mp3');
      setState(() {
        time = 0;
        initialHeight = characterY;
      });
    }
  }

  void startGame() {
    gameHasStarted = true;
    gameOver = false;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2 * time;
      setState(() {
        characterY = initialHeight - height;
        obstacleX -= 0.05;
      });

      if (obstacleX < -1.2) {
        obstacleX += 2.4;
        obstacleHeight = Random().nextInt(200).toDouble() + 100;
        score++;
        if (score > bestScore) {
          bestScore = score;
        }
      }

      if (characterY > 1 || characterY < -1) {
        _audioCache.play('game_over.mp3');
        setState(() {
          timer.cancel();
          gameHasStarted = false;
          gameOver = true;
        });
      }

      if (obstacleX < 0.1 && obstacleX > -0.1) {
        if (characterY >
                1 -
                    (widget.characterHeight /
                        MediaQuery.of(context).size.height) -
                    (obstacleHeight / MediaQuery.of(context).size.height) ||
            characterY <
                -1 +
                    (widget.characterHeight /
                        MediaQuery.of(context).size.height) +
                    (gapHeight / MediaQuery.of(context).size.height)) {
          _audioCache.play('game_over.mp3');
          setState(() {
            timer.cancel();
            gameHasStarted = false;
            gameOver = true;
          });
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      characterY = 0;
      time = 0;
      height = 0;
      initialHeight = 0;
      obstacleX = 1;
      gameHasStarted = false;
      gameOver = false;
      obstacleHeight = 200;
      score = 0;
    });
  }

  void selectNewCharacter(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CharacterSelection()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else if (!gameOver) {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(0, characterY),
                    duration: const Duration(milliseconds: 0),
                    child: Image.asset(
                      widget.character,
                      height: widget.characterHeight,
                      width: widget.characterWidth,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(obstacleX, 1),
                    duration: const Duration(milliseconds: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: obstacleHeight,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 45, 138, 73),
                            border: Border.all(width: 1.5, color: Colors.black),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        SizedBox(height: gapHeight),
                        Container(
                          height:
                              MediaQuery.of(context).size.height -
                              obstacleHeight -
                              gapHeight -
                              200,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 45, 138, 73),
                            border: Border.all(width: 1.5, color: Colors.black),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (gameOver)
                    Center(
                      child: Text(
                        'Game Over!!!\nScore: $score\nBest Score: $bestScore',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 81, 57, 48),
                child: Center(
                  child:
                      gameOver
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: resetGame,
                                child: const Text(
                                  'Restart',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () => selectNewCharacter(context),
                                child: const Text(
                                  'Select New Character',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
