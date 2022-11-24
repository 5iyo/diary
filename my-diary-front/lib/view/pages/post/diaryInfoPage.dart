import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class DiaryInfoPage extends StatefulWidget {
  const DiaryInfoPage({Key? key}) : super(key: key);

  @override
  State<DiaryInfoPage> createState() => _DiaryInfoPageState();
}

class _DiaryInfoPageState extends State<DiaryInfoPage> {
  // 'No.0'에서 'No.49'까지 표시하는 ListTile을 담은 리스트
  final _items = List.generate(50, (i) => ListTile(title: Text('No.$i')));
  final List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar( // 헤더 영역
            pinned: false, // 축소시 상단에 AppBar가 고정되는지 설정
            expandedHeight: MediaQuery
                .of(context)
                .size
                .height * 0.75, // 헤더의 최대 높이
            backgroundColor: Colors.white70,
            flexibleSpace: FlexibleSpaceBar( // 늘어나는 영역의 UI 정의
                title: Text('10월 10일 서울 여행'),
                background: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            "/diaryCardPage");
                      },
                      child: Hero(
                        tag: 'image0',
                        child: Swiper(
                          autoplay: true,
                          scale: 0.9,
                          viewportFraction: 0.8,
                          control: const SwiperControl(
                            color: Colors.white10,
                          ) ,
                          pagination: const SwiperPagination(
                              alignment: Alignment.bottomRight,
                              builder: DotSwiperPaginationBuilder(
                                  color: Colors.white,
                                  activeColor: Colors.white10
                              )
                          ),
                          itemCount: imgList.length,
                          itemBuilder: (BuildContext context, int index){
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                imgList[index],
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          },
                        ),
                      )
                  ),
                )
            ),
          ),
          SliverList(
            // 생성자에 표시할 위젯 리스트(_items)를 인수로 전달s
            delegate: SliverChildListDelegate(_items),
          ),
        ],
      ),
    );
  }
}