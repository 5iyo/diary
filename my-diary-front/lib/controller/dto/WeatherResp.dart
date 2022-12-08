
class Location {
  final String? x;
  final String? y;

  Location({
    this.x,
    this.y,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        x : json["x"],
        y : json["y"]
    );
  }
}

class Weather {
  final String? temp;
  final String? location;
  final Location? position;

  Weather(
      {
        this.temp,
        this.location,
        this.position,
      });

  factory Weather.fromJson(Map<String, dynamic> json) {

    return Weather(
      temp : json["temp"],
      location : json["location"],
      position: Location.fromJson(json["position"]),
    );
  }
}

class WeatherResp {
  final List<Weather>? weatherresp;

  WeatherResp({this.weatherresp});

  factory WeatherResp.fromJson(Map<String, dynamic> json) {

    var list = (json["response"] ?? []) as List;
    print(list.runtimeType);
    List<Weather> weatherlist = list.map((i) => Weather.fromJson(i)).toList();

    return WeatherResp(
        weatherresp : weatherlist
    );
  }
}