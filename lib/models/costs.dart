class CostModel {
  double? WaterTanker;
  double? Excavator;
  double? ForkLift;
  double? TractorTrolley;
  double? Truck;
  double? Eeco;
  double? Hydra;
  double? TataAce;
  double? ThreeWheeler;
  double? bike;
  double? HourlyRate;

  CostModel(
      { this.WaterTanker,
       this.bike,
       this.Eeco,
       this.Excavator,
       this.ForkLift,
       this.HourlyRate,
       this.Hydra,
       this.TataAce,
       this.ThreeWheeler,
       this.TractorTrolley,
       this.Truck});

  CostModel.fromJson(Map<dynamic, dynamic> json) {
    WaterTanker = double.parse(json['Water-Tanker'].toString()) ?? 0.0;
    bike = double.parse(json['Bike'].toString()) ?? 0.0;
    ForkLift = double.parse(json['Fork-Lift'].toString()) ?? 0.0;
    TractorTrolley = double.parse(json['Tractor-Trolley'].toString()) ?? 0.0;
    Truck = double.parse(json['Truck'].toString()) ?? 0.0;
    Excavator = double.parse(json['Excavator'].toString()) ?? 0.0;
    Eeco = double.parse(json['Eeco'].toString()) ?? 0.0;
    Hydra = double.parse(json['Hydra'].toString()) ?? 0.0;
    TataAce = double.parse(json['Tata-Ace'].toString()) ?? 0.0;
    ThreeWheeler = double.parse(json['Three-Wheeler'].toString()) ?? 0.0;
    HourlyRate = double.parse(json['HourlyRate'].toString()) ?? 0.0;
  }
}
