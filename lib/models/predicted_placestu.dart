class PredictedPlacestu
{
  String? place_id;
  String? main_text;
  String? secondary_text;

  PredictedPlacestu({
    this.place_id,
    this.main_text,
    this.secondary_text,
  });

  PredictedPlacestu.fromJson(Map<String, dynamic> jsonData)
  {
    place_id = jsonData["place_id"];
    main_text = jsonData["structured_formatting"]["main_text"];
    secondary_text = jsonData["structured_formatting"]["secondary_text"];
  }
}