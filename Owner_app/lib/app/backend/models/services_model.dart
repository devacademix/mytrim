class ServicesModel {
  int? id;
  int? uid;
  int? cateId;
  String? name;
  String? cover;
  double? duration;
  double? price;
  double? off;
  double? discount;
  String? descriptions;
  String? images;
  String? extraField;
  int? status;
  late bool? isChecked;
  WebCatesData? webCatesData;

  ServicesModel({
    this.id,
    this.uid,
    this.cateId,
    this.name,
    this.cover,
    this.duration,
    this.price,
    this.off,
    this.discount,
    this.descriptions,
    this.images,
    this.extraField,
    this.status,
    this.isChecked = false,
    this.webCatesData,
  });

  ServicesModel.fromJson(Map<String, dynamic> json) {
    id = num.tryParse(json['id']?.toString() ?? '')?.toInt() ?? 0;
    uid = num.tryParse(json['uid']?.toString() ?? '')?.toInt() ?? 0;
    cateId = num.tryParse(json['cate_id']?.toString() ?? '')?.toInt() ?? 0;
    name = json['name']?.toString() ?? '';
    cover = json['cover']?.toString() ?? '';
    duration = num.tryParse(json['duration']?.toString() ?? '')?.toDouble() ?? 0.0;
    price = num.tryParse(json['price']?.toString() ?? '')?.toDouble() ?? 0.0;
    off = num.tryParse(json['off']?.toString() ?? '')?.toDouble() ?? 0.0;
    discount = num.tryParse(json['discount']?.toString() ?? '')?.toDouble() ?? 0.0;
    descriptions = json['descriptions']?.toString() ?? '';
    images = json['images']?.toString() ?? '';
    extraField = json['extra_field']?.toString() ?? '';
    status = num.tryParse(json['status']?.toString() ?? '')?.toInt() ?? 1;
    webCatesData = json['web_cates_data'] != null ? WebCatesData.fromJson(json['web_cates_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['cate_id'] = cateId;
    data['name'] = name;
    data['cover'] = cover;
    data['duration'] = duration;
    data['price'] = price;
    data['off'] = off;
    data['discount'] = discount;
    data['descriptions'] = descriptions;
    data['images'] = images;
    data['extra_field'] = extraField;
    data['isChecked'] = isChecked;
    data['status'] = status;
    if (webCatesData != null) {
      data['web_cates_data'] = webCatesData!.toJson();
    }
    return data;
  }
}

class WebCatesData {
  int? id;
  String? name;
  String? cover;
  String? extraField;
  int? status;

  WebCatesData({this.id, this.name, this.cover, this.extraField, this.status});

  WebCatesData.fromJson(Map<String, dynamic> json) {
    id = num.tryParse(json['id']?.toString() ?? '')?.toInt() ?? 0;
    name = json['name']?.toString() ?? '';
    cover = json['cover']?.toString() ?? '';
    extraField = json['extra_field']?.toString() ?? '';
    status = num.tryParse(json['status']?.toString() ?? '')?.toInt() ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
