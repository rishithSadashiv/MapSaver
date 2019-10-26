class DazzJson {
  final String latitude;
  final String longitude;
  final String name;

  DazzJson(this.name, this.latitude, this.longitude);

  DazzJson.fromMappedJson(Map<String, dynamic> json)
      : name = json['name'],
        latitude = json['latitude'],
        longitude = json['longitude'] ;

  Map<String,dynamic> onlyPayload()=>{
    'name': name,
    'latitude': latitude,
    'longitude': longitude
  };

  Map<String, dynamic> toJson() => {
    'name': name,
    'longitude': latitude,
    'latitude': longitude
  };
}