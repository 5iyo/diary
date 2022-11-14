import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_diary_front/view/pages/post/travel_list_page.dart';
import 'package:my_diary_front/view/pages/post/write_page.dart';
import 'package:my_diary_front/view/pages/user/user_info.dart';
import 'package:get/get.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;
  int id = 1;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition =
  CameraPosition(target: LatLng(37.335887, 126.584063));

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  addMarker(coordinate) {
    setState(() {
      markers.add(
          Marker(
              position: coordinate,
              markerId: MarkerId((id).toString()),
              onTap: () {
                Get.to(()=>TravelListPage());
              }
          )
      );
    });
  }

  void _currentLocation() async {
    LocationData currentLocation;
    var location = new Location();
    currentLocation = await location.getLocation();
    addMarker(LatLng(currentLocation.latitude!, currentLocation.longitude!));
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 10.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Diary"),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('img/핑구.png'),
              ),
              accountName: Text('Pingu'),
              accountEmail: Text('pingu@pingu.com'),
              onDetailsPressed: (){
                print('arrow is clicked');
              },
              decoration: BoxDecoration(
                  color: Colors.blueGrey[400]
              ),
            ),
            ListTile(
              title: Text('회원 정보 보기'),
              onTap: () {
                Navigator.pop(context);
                Get.to(()=>UserInfo());
              },
            ),
            ListTile(
              title: Text('일기쓰기'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>WritePage())
                );
              },
            ),
            ListTile(
              title: Text('로그아웃'),
            )
          ],
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: markers.toSet(),
        zoomControlsEnabled: false,
        // 클릭한 위치가 중앙에 표시
        onTap: (coordinate) {
          _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
          addMarker(coordinate);
        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          _currentLocation();
        },
        child: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
