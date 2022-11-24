import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart' as card;

class DiaryImagePage extends StatefulWidget {
  const DiaryImagePage({Key? key}) : super(key: key);

  @override
  State<DiaryImagePage> createState() => _DiaryImagePageState();
}

class _DiaryImagePageState extends State<DiaryImagePage> {
  final List<String> imgList = [];
  late card.MatchEngine _matchEngine;
  List<card.SwipeItem> _SwipeItems = [];

  @override
  void initState() {
    imgList.forEach((element) {
      var swipeItem = card.SwipeItem(
          content: Image.asset(
            element,
            fit: BoxFit.fitHeight,
          ));
      _SwipeItems.add(swipeItem);
    });

    _matchEngine = card.MatchEngine(swipeItems: _SwipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: card.SwipeCards(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Hero(
                      tag: 'image',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          imgList[index],
                          fit: BoxFit.fitHeight,
                        ),
                      )
                  )
              );
            },
            matchEngine: _matchEngine,
            onStackFinished: () {
              Navigator.pop(context);
            },
          ),
        )
    );
  }
}
