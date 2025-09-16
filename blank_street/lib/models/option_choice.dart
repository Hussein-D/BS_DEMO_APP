import 'package:equatable/equatable.dart';

class OptionChoice extends Equatable {
  final String? id;
  final String? name;
  final int? priceCents;
  final bool? isSelected;
  const OptionChoice({
    this.id,
    this.name,
    this.priceCents = 0,
    this.isSelected,
  });
  factory OptionChoice.fromJson(Map<String, dynamic> json) => OptionChoice(
    id: json["id"],
    name: json["name"],
    priceCents: json["priceCents"],
    isSelected: json["isSelected"],
  );
  OptionChoice copyWith({bool? isSelected}) => OptionChoice(
    id: id,
    name: name,
    priceCents: priceCents,
    isSelected: isSelected ?? this.isSelected,
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "priceCents": priceCents,
    "isSelected": isSelected,
  };
  @override
  List<Object?> get props => [id];
}
