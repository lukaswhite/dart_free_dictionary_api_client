import './definitions.dart';
import '../mixins/synonyms.dart';
import '../mixins/antonyms.dart';

class Meanings with Synonyms, Antonyms {
  late String partOfSpeech;
  List<Definitions>? definitions;

  Meanings({required this.partOfSpeech, this.definitions});

  Meanings.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];
    if (json['definitions'] != null) {
      definitions = <Definitions>[];
      json['definitions'].forEach((v) {
        definitions!.add(Definitions.fromJson(v));
      });
    }
    if (json['synonyms'] != null) {
      synonyms = json['synonyms'].map((s) => s.toString()).toList().cast<String>();
    }
    if (json['antonyms'] != null) {
      antonyms = json['antonyms'].map((s) => s.toString()).toList().cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['partOfSpeech'] = partOfSpeech;
    if (definitions != null) {
      data['definitions'] = definitions!.map((v) => v.toJson()).toList();
    }
    if (synonyms != null) {
      data['synonyms'] = synonyms;
    }
    if (antonyms != null) {
      data['antonyms'] = antonyms;
    }
    return data;
  }
}