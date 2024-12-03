import 'package:aero_forecast/services/weather_services.dart';
import 'package:aero_forecast/widget/weather_data_tile.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  String _bgImg = 'assets/images/clear.jpg';
  String _iconImg = 'assets/icons/Clear.png';
  String _cityName = 'Cairo';
  String _temperature = '--';
  String _tempMax = '--';
  String _tempMin = '--';
  String _sunrise = '--';
  String _sunset = '--';
  String _main = 'Clear';
  String _presure = '--';
  String _humidity = '--';
  String _visibility = '--';
  String _windSpeed = '--';
  bool _isLoading = false; // To handle loading state

  getData(String cityName) async {
    setState(() {
      _isLoading = true;
    });

    final weatherService = WeatherService();
    var weatherData;
    try {
      if (cityName == '')
        weatherData = await weatherService.fetchWeather();
      else
        weatherData = await weatherService.getWeather(cityName);

      setState(() {
        _cityName = weatherData['name'];
        _temperature = weatherData['main']['temp'].toStringAsFixed(1);
        _main = weatherData['weather'][0]['main'];
        _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
        _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
        _sunrise = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherData['sys']['sunrise'] * 1000));
        _sunset = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherData['sys']['sunset'] * 1000));
        _presure = weatherData['main']['pressure'].toString();
        _humidity = weatherData['main']['humidity'].toString();
        _visibility = weatherData['visibility'].toString();
        _windSpeed = weatherData['wind']['speed'].toString();
        if (_main == 'Clear') {
          _bgImg = 'assets/images/clear.jpg';
          _iconImg = 'assets/icons/Clear.png';
        } else if (_main == 'Clouds') {
          _bgImg = 'assets/images/clouds.jpg';
          _iconImg = 'assets/icons/Clouds.png';
        } else if (_main == 'Rain') {
          _bgImg = 'assets/images/rain.jpg';
          _iconImg = 'assets/icons/Rain.png';
        } else if (_main == 'Fog') {
          _bgImg = 'assets/images/fog.jpg';
          _iconImg = 'assets/icons/Haze.png';
        } else if (_main == 'Thunderstorm') {
          _bgImg = 'assets/images/thunderstorm.jpg';
          _iconImg = 'assets/icons/Thunderstorm.png';
        } else {
          _bgImg = 'assets/images/haze.jpg';
          _iconImg = 'assets/icons/Haze.png';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to load data. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      getData('');
    }
    getData('');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          _bgImg,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      getData(value);
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: 'Enter City Name',
                      suffixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.black26),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on),
                    Text(
                      _cityName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                        '$_temperature°C',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 90,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                Row(
                  children: [
                    Text(
                      _main,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Image.asset(
                      _iconImg,
                      height: 80,
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_upward),
                    Text(
                      '$_tempMax°C',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Icon(Icons.arrow_downward),
                    Text(
                      '$_tempMin°C',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 5,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WeatherDataTile(
                              index1: "Sunrise",
                              index2: "Sunset",
                              value1: _sunrise,
                              value2: _sunset),
                          SizedBox(
                            height: 25,
                          ),
                          WeatherDataTile(
                              index1: "Humidity",
                              index2: "Visibility",
                              value1: _humidity,
                              value2: _visibility),
                          SizedBox(
                            height: 25,
                          ),
                          WeatherDataTile(
                              index1: "Pressure",
                              index2: "Wind Speed",
                              value1: _presure,
                              value2: _windSpeed),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
