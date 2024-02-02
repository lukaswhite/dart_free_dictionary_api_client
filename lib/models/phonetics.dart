import '../mixins/licenseable.dart';
import './license.dart';

class Phonetics with Licenseable {
  String? text;
  String? audio;
  String? sourceUrl;

  Phonetics({required this.text, this.audio, this.sourceUrl});

  Phonetics.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    audio = json['audio'];
    sourceUrl = json['sourceUrl'];
    if(json['license'] != null) {
      license = License.fromJson(json['license']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['audio'] = audio;
    data['sourceUrl'] = sourceUrl;
    if(license != null) {
      data['license'] = license?.toJson();
    }
    return data;
  }
}
