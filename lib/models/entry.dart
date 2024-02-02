import './phonetics.dart';
import './meanings.dart';
import './license.dart';
import '../mixins/licenseable.dart';

class Entry with Licenseable {
  late String word;
  String? phonetic;
  List<Phonetics>? phonetics;
  String? origin;
  List<Meanings>? meanings;
  List<String>? sourceUrls;

  Entry({required this.word, this.phonetic, this.phonetics, this.origin, this.meanings, this.sourceUrls});

  Entry.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    phonetic = json['phonetic'];
    if (json['phonetics'] != null) {
      phonetics = <Phonetics>[];
      json['phonetics'].forEach((v) {
        phonetics!.add(Phonetics.fromJson(v));
      });
    }
    origin = json['origin'];
    if (json['meanings'] != null) {
      meanings = <Meanings>[];
      json['meanings'].forEach((v) {
        meanings!.add(Meanings.fromJson(v));
      });
    }
    if(json['sourceUrls'] != null) {
      sourceUrls = json['sourceUrls'].map((s) => s.toString()).toList().cast<String>();
    }
    if(json['license'] != null) {
      license = License.fromJson(json['license']);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['phonetic'] = phonetic;
    if (phonetics != null) {
      data['phonetics'] = phonetics!.map((v) => v.toJson()).toList();
    }
    data['origin'] = origin;
    if (meanings != null) {
      data['meanings'] = meanings!.map((v) => v.toJson()).toList();
    }
    if(license != null) {
      data['license'] = license?.toJson();
    }
    return data;
  }
}