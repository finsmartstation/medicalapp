class AccessModel {
  AccessModel({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });
  late final int status;
  late final bool statuscode;
  late final String message;
  late final List<Data> data;
  
  AccessModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    statuscode = json['statuscode'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['statuscode'] = statuscode;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.accessName,
    required this.status,
  });
  late final String id;
  late final String accessName;
  late final String status;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    accessName = json['access_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['access_name'] = accessName;
    _data['status'] = status;
    return _data;
  }
}