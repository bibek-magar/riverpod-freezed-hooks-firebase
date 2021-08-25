import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

//toString hashcode equality
part 'item_model.freezed.dart';
//From JSON & to JSON
part 'item.model.g.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    String? id,
    required String name,
    @Default(false) bool obtained,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
