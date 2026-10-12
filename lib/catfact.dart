// MODEL: turns JSON from the API into a typed Dart object.
class CatFact {
  final String fact;
  final int length;

  CatFact({required this.fact, required this.length});

  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(fact: json['fact'] as String, length: json['length'] as int);
  }
}
