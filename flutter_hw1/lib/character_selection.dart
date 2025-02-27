import 'package:flutter/material.dart';
import 'game.dart';

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({super.key});

  final List<String> characters = const [
    'assets/chan.png',
    'assets/leeknow.png',
    'assets/bin.png',
    'assets/jin.png',
    'assets/han.png',
    'assets/felix.png',
    'assets/puppym.png',
    'assets/in.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Character')),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9, // 設置高度為屏幕高度的 90%
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3, // 設置子項的寬高比為 1.3
              mainAxisSpacing: 8, // 設置主軸間距
              crossAxisSpacing: 8, // 設置交叉軸間距
            ),
            padding: const EdgeInsets.all(10), // 設置內邊距
            itemCount: characters.length,
            itemBuilder: (context, index) {
              double characterHeight = 80; // 默認角色高度
              double characterWidth = 80; // 默認角色寬度

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => JumpGame(
                            character: characters[index],
                            characterHeight: characterHeight,
                            characterWidth: characterWidth,
                          ),
                    ),
                  );
                },
                child: Card(
                  elevation: 1, // 設置陰影
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 設置圓角
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5), // 設置圓角
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AspectRatio(
                        aspectRatio: 1, // 設置寬高比為 1
                        child: Image.asset(
                          characters[index],
                          fit: BoxFit.cover, // 設置圖片填充方式
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
