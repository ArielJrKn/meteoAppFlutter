class Meteo {
  final String time;
  final double temperature;
  final double windspeed;
  final int winddirection;
  final bool isDay;
  final int code;

  Meteo({
    required this.time,
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.isDay,
    required this.code,
  });

  factory Meteo.fromJson(Map<String, dynamic> json) {
    // ⚠️ Les données sont dans current_weather
    final current = json['current_weather'] as Map<String, dynamic>?;

    if (current == null) {
      throw Exception('Réponse invalide : champ current_weather manquant');
    }

    return Meteo(
      time:         current['time'] as String? ?? '',
      temperature:  (current['temperature'] as num?)?.toDouble() ?? 0.0,
      windspeed:    (current['windspeed'] as num?)?.toDouble() ?? 0.0,
      winddirection:(current['winddirection'] as num?)?.toInt() ?? 0,
      isDay:        (current['is_day'] as num?)?.toInt() == 1, // int → bool
      code:         (current['weathercode'] as num?)?.toInt() ?? 0,
    );
  }

  static Map<String, String> decoderMeteo(int code) {
    final Map<int, Map<String, String>> map = {
      0:  {"emoji": "☀️", "desc": "Ciel dégagé",              "fond": "orangeAccent"},
      1:  {"emoji": "🌤️", "desc": "Principalement dégagé",     "fond": "orangeAccent"},
      2:  {"emoji": "⛅",  "desc": "Partiellement nuageux",     "fond": "orangeAccent"},
      3:  {"emoji": "☁️", "desc": "Nuageux",                   "fond": "blueAccent"},
      45: {"emoji": "🌫️", "desc": "Brouillard",                "fond": "blueAccent"},
      48: {"emoji": "🌫️", "desc": "Brouillard givrant",        "fond": "blueAccent"},
      51: {"emoji": "🌦️", "desc": "Bruine légère",             "fond": "blueAccent"},
      53: {"emoji": "🌦️", "desc": "Bruine modérée",            "fond": "blueAccent"},
      55: {"emoji": "🌧️", "desc": "Bruine dense",              "fond": "blueAccent"},
      61: {"emoji": "🌧️", "desc": "Pluie légère",              "fond": "blueAccent"},
      63: {"emoji": "🌧️", "desc": "Pluie modérée",             "fond": "blueAccent"},
      65: {"emoji": "🌧️", "desc": "Pluie forte",               "fond": "blueAccent"},
      71: {"emoji": "🌨️", "desc": "Neige légère",              "fond": "white"},
      73: {"emoji": "🌨️", "desc": "Neige modérée",             "fond": "white"},
      75: {"emoji": "❄️", "desc": "Neige forte",               "fond": "white"},
      80: {"emoji": "🌦️", "desc": "Averses légères",           "fond": "blueAccent"},
      81: {"emoji": "🌧️", "desc": "Averses modérées",          "fond": "blueAccent"},
      82: {"emoji": "⛈️", "desc": "Averses violentes",         "fond": "blueAccent"},
      95: {"emoji": "⛈️", "desc": "Orage",                     "fond": "blueAccent"},
      96: {"emoji": "⛈️", "desc": "Orage avec grêle",          "fond": "blueAccent"},
      99: {"emoji": "⛈️", "desc": "Orage violent",             "fond": "blueAccent"},
    };

    return map[code] ??
        {"emoji": "🌡️", "desc": "Conditions inconnues", "fond": ""};
  }
}