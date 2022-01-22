import 'package:test_app/components/models/item_model.dart';

class ObjectModel {
  ObjectModel({
    List<String>? columns,
    List<ItemModel>? listItems,
  }) {
    _columns = columns;
    _listItems = listItems;
  }

  ObjectModel.fromJson(dynamic json) {
    _columns = json['columns'];
    _listItems = json['listItems'];
  }

  List<String>? _columns;
  List<ItemModel>? _listItems;

  List<String>? get columns => _columns;
  List<ItemModel>? get listItems => _listItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['columns'] = _columns;
    map['listItems'] = _listItems;
    return map;
  }

  set columns(List<String>? value) {
    _columns = value;
  }

  set listItems(List<ItemModel>? value) {
    _listItems = value;
  }
}
