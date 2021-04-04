class Prefecture {
  final String name;
  final String date;
  final int count;

  Prefecture({this.name, this.date, this.count});

  factory Prefecture.fromJson(Map<String, dynamic> json) {
    return Prefecture(
      name: json['name'],
      date: json['date'],
      count: json['count'],
    );
  }
}
