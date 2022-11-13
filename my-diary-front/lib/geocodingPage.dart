import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as place;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:location/location.dart';

class GeocodingPage extends StatefulWidget {
  const GeocodingPage({Key? key}) : super(key: key);

  @override
  State<GeocodingPage> createState() => _GeocodingPageState();
}

class _GeocodingPageState extends State<GeocodingPage> {
  // 애플리케이션에서 지도를 이동하기 위한 컨트롤러
  late GoogleMapController _controller;
  int id = 1;

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.
  final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(36.30808077893056, 127.66468472778797), zoom: 7.0);

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final List<Marker> markers = [];

  addMarker(LatLng coordinate, InfoWindow infoWindow) {
    print("${coordinate.latitude}, ${coordinate.longitude}");
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId((id).toString()),
        infoWindow: infoWindow,
      ));
    });
  }

  clearMarker() {
    setState(() {
      markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: buildGoogleMap()),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchPlaces,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildGoogleMap() {
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
      // 클릭한 위치가 중앙에 표시
/*        onCameraMove: (position) {
          if ((position.target.longitude < 131.5222 &&
                  position.target.longitude > 124.1051) &&
              (position.target.latitude < 43.0042 &&
                  position.target.latitude > 33.0643)) {
            print("${position.target.latitude}, ${position.target.longitude}");
          } else {
            print("${position.target.latitude}, ${position.target.longitude}");
          }
        }*/
    );
  }

  final Mode _mode = Mode.overlay;

  Future _searchPlaces() async {
    place.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: dotenv.get('GOOGLE_MAP_KEY'),
        onError: onError,
        mode: _mode,
        language: 'kr',
        strictbounds: false,
        types: [""],
        decoration: const InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
        components: [place.Component(place.Component.country, "kr")]);
    if (p != null) {
      displayPrediction(p);
    }
  }

  void onError(place.PlacesAutocompleteResponse response) {
    print("${response.errorMessage}");
  }

  Future displayPrediction(place.Prediction p) async {
    place.GoogleMapsPlaces places = place.GoogleMapsPlaces(
        apiKey: dotenv.get('GOOGLE_MAP_KEY'),
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    place.PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    clearMarker();
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
