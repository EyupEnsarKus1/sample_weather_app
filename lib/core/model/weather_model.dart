class CurrentWeatherData {
  final String name;
  final Weather weather;
  final Temperature temperature;
  final Wind wind;

  CurrentWeatherData({
    required this.name,
    required this.weather,
    required this.temperature,
    required this.wind,
  });

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherData(
      name: json['name'],
      weather: Weather.fromJson(json['weather'][0]),
      temperature: Temperature.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
    );
  }
}

class WeatherData {
  final City city;
  final List<WeatherForecast> forecastList;

  WeatherData({required this.city, required this.forecastList});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    List<WeatherForecast> forecastList = list.map((i) => WeatherForecast.fromJson(i)).toList();

    return WeatherData(
      city: City.fromJson(json['city']),
      forecastList: forecastList,
    );
  }
}

class City {
  final String name;
  final String country;

  City({required this.name, required this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['country'],
    );
  }
}

class WeatherForecast {
  final DateTime dateTime;
  final Temperature temperature;
  final Weather weather;
  final Wind wind;

  WeatherForecast({required this.dateTime, required this.temperature, required this.weather, required this.wind});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: Temperature.fromJson(json['main']),
      weather: Weather.fromJson(json['weather'][0]),
      wind: Wind.fromJson(json['wind']),
    );
  }
}

class Temperature {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  Temperature({required this.temp, required this.feelsLike, required this.tempMin, required this.tempMax});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
    );
  }
}

class Weather {
  final String main;
  final String description;
  final String icon;

  Weather({required this.main, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Wind {
  final double speed;
  final int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
    );
  }
}
