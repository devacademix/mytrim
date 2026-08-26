class SalonModel {
  int? id;
  int? salonUid;
  String? cateId;
  String? firstName;
  String? lastName;
  String? cover;
  String? extraField;
  int? status;
  bool? isChecked;
  List<Categories>? categories;

  SalonModel({this.id, this.salonUid, this.cateId, this.firstName, this.lastName, this.cover, this.extraField, this.status, this.categories, this.isChecked});

  SalonModel.fromJson(Map<String, dynamic> json) {
    id = num.tryParse(json['id']?.toString() ?? '')?.toInt() ?? 0;
    salonUid = num.tryParse(json['salon_uid']?.toString() ?? '')?.toInt() ?? 0;
    cateId = json['cate_id']?.toString() ?? '';
    firstName = json['first_name']?.toString() ?? '';
    lastName = json['last_name']?.toString() ?? '';
    cover = json['cover']?.toString() ?? '';
    extraField = json['extra_field']?.toString() ?? '';
    isChecked = json['isChecked'] ?? false;
    status = num.tryParse(json['status']?.toString() ?? '')?.toInt() ?? 1;
    if (json['categories'] != null && json['categories'] is List) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        if (v != null) {
          categories!.add(Categories.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon_uid'] = salonUid;
    data['cate_id'] = cateId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['isChecked'] = isChecked;
    data['status'] = status;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? cover;

  Categories({this.id, this.name, this.cover});

  Categories.fromJson(Map<String, dynamic> json) {
    id = num.tryParse(json['id']?.toString() ?? '')?.toInt() ?? 0;
    name = json['name']?.toString() ?? '';
    cover = json['cover']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    return data;
  }
}
