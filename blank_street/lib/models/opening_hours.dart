class OpeningHours {
  final String? open;
  final String? close;
  const OpeningHours({this.close, this.open});
  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      OpeningHours(open: json["open"], close: json["close"]);
}
