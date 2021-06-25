import 'package:object_mapper/object_mapper.dart';

/// sku : ""
/// name : ""
/// locationCode : ""
/// qty : 10
/// unit : ""

class Materiel with Mappable {
  String? _state;
  String? _sku;
  String? _name;
  String? _locationCode;
  String? _qty;
  String? _unit;

  String? get state => _state;



  String? get sku => _sku;

  String? get name => _name;

  String? get locationCode => _locationCode;

  String? get qty => _qty;

  String? get unit => _unit;



  Materiel(
      {String? state,
      String? sku,
      String? name,
      String? locationCode,
      String? qty,
      String? unit}) {
    _state = state;
    _sku = sku;
    _name = name;
    _locationCode = locationCode;
    _qty = qty;
    _unit = unit;
  }

  Materiel.fromJson(dynamic json) {
    _state = json["state"];
    _sku = json["sku"];
    _name = json["name"];
    _locationCode = json["locationCode"];
    _qty = json["qty"];
    _unit = json["unit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["state"] = _state;
    map["sku"] = _sku;
    map["name"] = _name;
    map["locationCode"] = _locationCode;
    map["qty"] = _qty;
    map["unit"] = _unit;
    return map;
  }

  @override
  void mapping(Mapper map) {
    map("state", _state, (v) => _state = v);
    map("sku", _sku, (v) => _sku = v);
    map("name", _name, (v) => _name = v);
    map("locationCode", _locationCode, (v) => _locationCode = v);
    map("qty", _qty, (v) => _qty = v);
    map("unit", _unit, (v) => _unit = v);
  }
}
