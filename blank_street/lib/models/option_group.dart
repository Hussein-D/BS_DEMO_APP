import 'package:blank_street/models/option_choice.dart';
import 'package:equatable/equatable.dart';

class OptionGroup extends Equatable {
  final String? id;
  final String? name;
  final int? min;
  final int? max;
  final List<OptionChoice>? choices;
  const OptionGroup({this.id, this.name, this.min, this.max, this.choices});
  factory OptionGroup.fromJson(Map<String, dynamic> json) => OptionGroup(
    id: json["id"],
    name: json["name"],
    max: json["max"],
    min: json["min"],
    choices: List.generate(
      (json["choices"] as List? ?? []).length,
      (i) => OptionChoice.fromJson((json["choices"] as List? ?? [])[i]),
    ),
  );
  OptionGroup copyWith({List<OptionChoice>? choices}) => OptionGroup(
    id: id,
    name: name,
    max: max,
    min: min,
    choices: List.from(choices ?? this.choices ?? []),
  );
    Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "max": max,
    "min": min,
    "choices": List.generate(
      (choices ?? []).length,
      (i) => (choices ?? [])[i].toJson(),
    ),
  };
  @override
  List<Object?> get props => [id];
}
