import 'dart:convert';

class Model1 {
  final List<Model2> a;
  final String d;

  Model1({
    this.a,
    this.d,
  });

  Map<String, dynamic> toMap() {
    return {
      'a': a?.map((x) => x?.toMap())?.toList(),
      'd': d,
    };
  }

  factory Model1.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Model1(
      a: List<Model2>.from(map['a']?.map((x) => Model2.fromMap(x))),
      d: map['d'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Model1.fromJson(String source) => Model1.fromMap(json.decode(source));
}

/// {
///         "b": 0,
///         "c": "test"
///  }
class Model2 {
  final int b;
  final String c;
  Model2({
    this.b,
    this.c,
  });

  Map<String, dynamic> toMap() {
    return {
      'b': b,
      'c': c,
    };
  }

  factory Model2.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Model2(
      b: map['b'],
      c: map['c'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Model2.fromJson(String source) => Model2.fromMap(json.decode(source));
}
