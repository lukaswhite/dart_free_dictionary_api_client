import '../mixins/synonyms.dart';
import '../mixins/antonyms.dart';

class Definitions with Synonyms, Antonyms {
  late String definition;
  String? example;
  
  Definitions({required this.definition, this.example});

  Definitions.fromJson(Map<String, dynamic> json) {
    definition = json['definition'];
    example = json['example'];
    if (json['synonyms'] != null) {
      synonyms = json['synonyms'].map((s) => s.toString()).toList().cast<String>();
    }
    if (json['antonyms'] != null) {
      antonyms = json['antonyms'].map((s) => s.toString()).toList().cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['definition'] = definition;
    data['example'] = example;
    if (synonyms != null) {
      data['synonyms'] = synonyms;
    }
    if (antonyms != null) {
      data['antonyms'] = antonyms;
    }
    return data;
  }
}