import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:my_diary_front/data.dart';
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

import '../../../diaryShare.dart';

import '../../../controller/dto/TravelList_travels.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late MainViewModel _mainViewModel;

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

  DiaryScreenshot diaryScreenshot = DiaryScreenshot();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  addMarker(coordinate, InfoWindow infoWindow, [TravelMarker? travelMarker]) {
    markers.add(travelMarker == null
        ? Marker(
            position: coordinate,
            markerId: MarkerId((markerId).toString()),
            infoWindow: infoWindow,
          )
        : Marker(
            position: coordinate,
            markerId: MarkerId((markerId++).toString()),
            infoWindow: infoWindow,
          ));
    setState(() {
      setOfMarkers = markers.toSet();
    });
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

  void initMarkers(TravelMarkerList list) {
    print("##############${markers.length}");
    markers.clear();
    print(markers.length);
    list.travelMarkers!.map((e) => addMarker(
        e.travelLatLng,
        InfoWindow(
            title: e.travelArea,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelListPage(
                            travelLatLng: e.travelLatLng,
                          )));
            }),
        e));
  }

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
    initMarkers(_mainViewModel.diaryUser!.travels);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Screenshot(
        controller: diaryScreenshot.screenshotController,
        child: _buildGoogleMap(),
      ),
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
      elevation: 8.0,
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
          (item) async {
            await _controller
                .takeSnapshot()
                .then((value) => _mainViewModel.share(
                      item,
                      diaryScreenshot,
                      value,
                    ));
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
              backgroundImage: _mainViewModel.diaryUser!.profileImage == null
                  ? const AssetImage('img/핑구.png')
                  : Image.network(_mainViewModel.diaryUser!.profileImage!)
                      .image,
            ),
            accountName: Text(_mainViewModel.diaryUser!.username),
            accountEmail: Text(_mainViewModel.diaryUser!.email),
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
          ListTile(
            title: const Text('일기쓰기'),
            onTap: () {
              //FixMe : 일기쓰기가 무슨 페이지로 가는 버튼인지 확실히 알아보기
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TravelPage("")));
            },
          ),
          ListTile(
            title: const Text('여행지 추천'),
            onTap: () {
              Get.to(() => WeatherPage());
            },
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () => _mainViewModel.logout(),
          )
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      mapType: MapType.hybrid,
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
        addMarker(coordinate, InfoWindow());
      },
      cameraTargetBounds: CameraTargetBounds(LatLngBounds(
          southwest: const LatLng(33.0643, 124.3636),
          northeast: const LatLng(38.3640, 131.5222))),
      minMaxZoomPreference: const MinMaxZoomPreference(7.0, 15.0),
    );
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
            // TODO : 맑음 지역 받아오기 + initMarkers(맑음 지역 list)
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
            await _mainViewModel.diaryUser!.getTravelMarkerList();
            initMarkers(_mainViewModel.diaryUser!.travels);
            _controller.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition));
          },
        ),
      ],

      // animation controller
      animation: _animation,

      // On pressed change animation state
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),

      // Floating Action button Icon color
      iconColor: Colors.white,

      // Flaoting Action button Icon
      iconData: Icons.menu,
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
      language: 'kr',
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
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final latLng = LatLng(lat, lng);

    addMarker(
        latLng,
        InfoWindow(
            title: detail.result.name,
            onTap: () {
              Get.to(() => TravelPage(_mainViewModel.diaryUser!.id.toString(), latLng));
//              Navigator.pushNamed(context, '/diaryInfoPage');
            }));

    _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}
