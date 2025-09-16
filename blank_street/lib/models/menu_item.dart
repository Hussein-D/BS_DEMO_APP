import 'package:blank_street/models/option_group.dart';
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final int? basePriceCents;
  final List<OptionGroup>? optionGroups;
  final bool? isSelected;
  final int? quantity;
  const MenuItem({
    this.id,
    this.name,
    this.description,
    this.basePriceCents,
    this.optionGroups,
    this.isSelected,
    this.quantity,
  });
  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    basePriceCents: json["basePriceCents"],
    optionGroups: List.generate(
      (json["optionGroups"] as List? ?? []).length,
      (i) => OptionGroup.fromJson((json["optionGroups"] as List? ?? [])[i]),
    ),
  );
  MenuItem copyWith({
    bool? isSelected,
    int? quantity,
    List<OptionGroup>? groups,
  }) => MenuItem(
    id: id,
    name: name,
    description: description,
    basePriceCents: basePriceCents,
    isSelected: isSelected ?? this.isSelected,
    quantity: quantity ?? this.quantity,
    optionGroups: List.from(groups ?? optionGroups ?? []),
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "basePriceCents": basePriceCents,
    "optionGroups": List.generate(
      (optionGroups ?? []).length,
      (i) => (optionGroups ?? [])[i].toJson(),
    ),
  };
  @override
  List<Object?> get props => [id];
}
