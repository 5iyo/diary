import 'dart:convert';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/recommend_page.dart';
import 'package:my_diary_front/view/pages/post/travel_list_page.dart';
import 'package:my_diary_front/view/pages/post/travel_page.dart';
import 'package:my_diary_front/view/pages/post/weather_page.dart';
import 'package:my_diary_front/view/pages/post/write_page.dart';
import 'package:my_diary_front/view/pages/user/user_info.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

import '../../../controller/dto/WeatherResp.dart';
import '../../../diaryShare.dart';

import '../../../controller/dto/TravelList_travels.dart';

import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  MainViewModel? _mainViewModel;

  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;
  int markerId = 1;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition = const CameraPosition(
      target: LatLng(36.30808077893056, 127.66468472778797), zoom: 7.0);

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  List<Marker> markers = [];
  Set<Marker> setOfMarkers = {};

  late Animation<double> _animation;
  late AnimationController _animationController;

  bool isAwait = false;

  DiaryScreenshot diaryScreenshot = DiaryScreenshot();

  @override
  void initState() {
    print('initState');
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  addMarker(LatLng coordinate, InfoWindow infoWindow,
      [TravelMarker? travelMarker, BitmapDescriptor icon = BitmapDescriptor.defaultMarker]) {
    print("#######addMarker ${markerId}");
    markers.add(travelMarker == null
        ? Marker(
            position: coordinate,
            markerId: MarkerId("$markerId"),
            infoWindow: infoWindow,
      icon: icon
          )
        : Marker(
            position: coordinate,
            markerId: MarkerId("${markerId++}"),
            infoWindow: infoWindow,
        icon: icon
          ));
    setState(() {
      setOfMarkers = markers.toSet();
    });
    print("#######addMarker ${markers.length} & ${setOfMarkers.length}");
//    print("#######addMarker ${travelMarker!.travelLatLng.latitude} & ${travelMarker.travelLatLng.longitude}");
  }

  void _currentLocation() async {
    loc.LocationData currentLocation;
    var location = loc.Location();
    currentLocation = await location.getLocation();
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  void initMarkers(TravelMarkerList list, [Function(TravelMarker)? onTap, BitmapDescriptor icon = BitmapDescriptor.defaultMarker]) {
    print("#######initMarkers");
    if (list.travelMarkers!.isEmpty) {
      setState(() {
        setOfMarkers = {};
      });
    }
//    markers.clear();
    for (TravelMarker e in list.travelMarkers!) {
      print(
          "#######initMarkers ${e.travelLatLng.latitude} & ${e.travelLatLng.longitude}");
      addMarker(
          e.travelLatLng,
          InfoWindow(
              title: e.travelTitle,
              onTap: onTap == null
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TravelListPage(
                                    travelLatLng: e.travelLatLng,
                                  )));
                    }
                  : () => onTap(e)),
          e, icon);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("#######build");
    if (_mainViewModel == null) {
      _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
      initMarkers(_mainViewModel!.diaryUser!.travels);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Stack(children: [
        Screenshot(
            controller: diaryScreenshot.screenshotController,
            child: UiViewModel.buildBackgroundContainer(
                context: context,
                backgroundType: BackgroundType.none,
                child: UiViewModel.buildSizedLayout(
                    context,
                    Card(
                      elevation: 16.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                          child: _buildGoogleMap()),
                    )))),
        isAwait ? UiViewModel.buildProgressBar() : Container(),
      ]),
      floatingActionButton: _buildFloatingActionBubble(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'OIYO My Diary',
      ),
      backgroundColor: Colors.blueGrey[400]!.withOpacity(0.4),
      centerTitle: true,
      shadowColor: Colors.black,
      elevation: 0.1,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        );
      }),
      actions: [
        DiarySocialShareViewModel().buildPopupMenu(
          context,
          (DiarySocialShare item) async {
            setState(() {
              isAwait = true;
            });
            await _controller
                .takeSnapshot()
                .then((value) => _mainViewModel!.share(
                      item,
                      diaryScreenshot,
                      value,
                    ))
                .then((value) {
              setState(() {
                isAwait = false;
              });
              value
                  ? ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${item.name} 공유 완료")))
                  : ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${item.name} 공유 실패")));
            });
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: _mainViewModel!.diaryUser!.profileImage == null
                  ? const AssetImage('img/핑구.png')
                  : Image.network(_mainViewModel!.diaryUser!.profileImage!)
                      .image,
            ),
            accountName: Text(_mainViewModel!.diaryUser!.username),
            accountEmail: Text(_mainViewModel!.diaryUser!.email),
            decoration: BoxDecoration(color: Colors.blueGrey[400]),
          ),
          ListTile(
            title: const Text('회원 정보 보기'),
            onTap: () {
              //Navigator.pop(context);
              Get.to(() => const UserInfo());
              //Navigator.pushNamed(context, "/userInfoPage");
            },
          ),
/*          ListTile(
            title: const Text('여행 조회'),
            onTap: () {
              //FixMe : 여행 조회 페이지 만들고 _mainViewModel.diaryUser.travels.travelMarkers 랑 연결하기
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TravelPage("")));
            },
          ),*/
          ListTile(
            title: const Text('여행지 추천'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/weatherPage").then((value) {
                if (value.runtimeType == TravelMarker) {
                  var result = value as TravelMarker;
                  print("after push weather_page");
//                  markers.clear();
                  TravelMarkerList list = TravelMarkerList();
                  list.travelMarkers = [result];
                  initMarkers(list, (e) {}, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));
                  _controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: result.travelLatLng, zoom: 14.0)));
                }
              });
//              Get.to(() => WeatherPage());
            },
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () => _mainViewModel!.logout(),
          )
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      mapType: MapType.normal,
      onMapCreated: (controller) {
        setState(() {
          _controller = controller;
        });
      },
      markers: setOfMarkers,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // 클릭한 위치가 중앙에 표시
      onTap: (coordinate) {
        FocusScope.of(context).unfocus();
        _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
      },
      cameraTargetBounds: CameraTargetBounds(LatLngBounds(
          southwest: const LatLng(33.0643, 124.3636),
          northeast: const LatLng(38.3640, 131.5222))),
      minMaxZoomPreference: const MinMaxZoomPreference(7.0, 15.0),
    );
  }

  Future<WeatherResp> fetchWeather() async {
    var url = '${dotenv.get('SERVER_URI')}/weather/clear';
    setState(() {
      isAwait = true;
    });
    final response = await http.get(Uri.parse(url));
    setState(() {
      isAwait = false;
    });
    if (response.statusCode == 200) {
      print("날씨 리스트 요청 성공");
      print(json.decode(utf8.decode(response.bodyBytes)));
      return WeatherResp.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 500) {
      throw Exception("날씨 리스트가 없습니다.");
    } else {
      throw Exception("날씨 리스트 요청을 실패했습니다.");
    }
  }

  Widget _buildFloatingActionBubble() {
    return FloatingActionBubble(

      // Menu items
      items: <Bubble>[
        // Floating action menu item
        Bubble(
          title: "Hot Places",
          iconColor: Colors.white,
          bubbleColor: Colors.blueGrey[400]!.withOpacity(0.4),
          icon: Icons.local_fire_department_rounded,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            _animationController.reverse();
            setState(() {
              isAwait = true;
            });
            await fetchWeather().then((value) {
              TravelMarkerList list = TravelMarkerList();
              list.travelMarkers = value.weatherresp!
                  .map((e) => TravelMarker(
                      travelTitle: e.location!,
                      travelArea: "",
                      travelLatLng: LatLng(double.parse(e.position!.y!),
                          double.parse(e.position!.x!)),
                      travelImage: ""))
                  .toList();
              markers.clear();
              initMarkers(list, (TravelMarker e) {
                print("onclick");
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecommendPage(
                                e.travelTitle,
                                e.travelLatLng.latitude.toString(),
                                e.travelLatLng.longitude.toString())))
                    .then((value) {
                  if (value.runtimeType == TravelMarker) {
                    print("after push weather_page");
//                    markers.clear();
                    TravelMarkerList list = TravelMarkerList();
                    list.travelMarkers = [value];
                    initMarkers(list, (e) {}, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet));
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: value.travelLatLng, zoom: 14.0)));
                  }
                });
//                Get.to(()=> RecommendPage(e.travelTitle, e.travelLatLng.latitude.toString(), e.travelLatLng.longitude.toString()));
              }, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta));
            });
            setState(() {
              isAwait = false;
            });
            _controller.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition));
          },
        ),
        // Floating action menu item
        Bubble(
          title: "Add Travel",
          iconColor: Colors.white,
          bubbleColor: Colors.blueGrey[400]!.withOpacity(0.4),
          icon: Icons.add,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            _animationController.reverse();
            _searchPlaces();
          },
        ),
        //Floating action menu item
        Bubble(
          title: "Home",
          iconColor: Colors.white,
          bubbleColor: Colors.blueGrey[400]!.withOpacity(0.4),
          icon: Icons.home,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            _animationController.reverse();
            markers.clear();
            setState(() {
              isAwait = true;
            });
            await _mainViewModel!.diaryUser!.getTravelMarkerList();
            setState(() {
              isAwait = false;
            });
            initMarkers(_mainViewModel!.diaryUser!.travels);
            _controller.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition));
          },
        ),
      ],

      // animation controller
      animation: _animation,

      // On pressed change animation state
      onPress: () => isAwait ? null : _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),

      // Floating Action button Icon color
      iconColor: Colors.white,

      // Flaoting Action button Icon
      iconData: Icons.format_list_bulleted,
      backGroundColor: Colors.blueGrey[400]!.withOpacity(0.4),
    );
  }

  final Mode _mode = Mode.overlay;

  Future _searchPlaces() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: dotenv.get('GOOGLE_MAP_KEY'),
      onError: onError,
      mode: _mode,
      language: 'ko',
      strictbounds: false,
      types: [],
      decoration: const InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Colors.white),
        ),
      ),
      components: [Component(Component.country, "kr")],
      region: "kr",
      logo: Column(),
      offset: 0,
    );
    if (p != null) {
      displayPrediction(p);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    print("${response.errorMessage}");
  }

  Future displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: dotenv.get('GOOGLE_MAP_KEY'),
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId!, language: "ko");

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final latLng = LatLng(lat, lng);

    addMarker(
        latLng,
        InfoWindow(
            title: detail.result.name,
            onTap: () {
              Get.to(() =>
                  TravelPage(_mainViewModel!.diaryUser!.id.toString(), latLng));
//              Navigator.pushNamed(context, '/diaryInfoPage');
            }), null, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));

    _controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.0));
  }
}
