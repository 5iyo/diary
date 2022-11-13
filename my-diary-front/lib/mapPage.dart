import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;
  int id = 1;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(36.30808077893056, 127.66468472778797), zoom: 7.0);

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  addMarker(coordinate, InfoWindow infoWindow) {
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId((id).toString()),
        infoWindow: infoWindow,
      ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildGoogleMap(),
      floatingActionButton: _buildFloatingActionBubble(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        '로그인',
      ),
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        );
      }),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
          // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              // 현재 계정 이미지 set
//                backgroundImage: AssetImage('assets/profile.png'),
              backgroundColor: Colors.white,
            ),
            accountName: Text(""),
            accountEmail: Text(""),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0))),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
            trailing: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text(
              'Setting',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
            trailing: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.question_answer,
              color: Colors.black,
            ),
            title: const Text(
              'Q&A',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
            trailing: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
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
      markers: markers.toSet(),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // 클릭한 위치가 중앙에 표시
      onTap: (coordinate) {
        FocusScope.of(context).unfocus();
        _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
      },
    );
  }

  Widget _buildFloatingActionBubble() {
    return FloatingActionBubble(
      // Menu items
      items: <Bubble>[
        // Floating action menu item
        Bubble(
          title: "Settings",
          iconColor: Colors.white,
          bubbleColor: Colors.white.withOpacity(0.4),
          icon: Icons.settings,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            _animationController.reverse();
          },
        ),
        // Floating action menu item
        Bubble(
          title: "Profile",
          iconColor: Colors.white,
          bubbleColor: Colors.white.withOpacity(0.4),
          icon: Icons.people,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            _animationController.reverse();
          },
        ),
        //Floating action menu item
        Bubble(
          title: "Home",
          iconColor: Colors.white,
          bubbleColor: Colors.white.withOpacity(0.4),
          icon: Icons.home,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            _animationController.reverse();
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
      backGroundColor: Colors.white.withOpacity(0.4),
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

    addMarker(
        LatLng(lat, lng),
        InfoWindow(
            title: detail.result.name,
            onTap: () {
              Navigator.pushNamed(context, '/diaryInfoPage');
            }));

    _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}
