import './models/entry.dart';
import './exceptions/dictionary_load_exception.dart';
import './exceptions/dictionary_not_found_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DictionaryApi {

  final http.Client _client;

  String host = 'api.dictionaryapi.dev';
  String version = 'v2';
  String language = 'en';

  DictionaryApi(this._client);

  Future<List<Entry>> lookup(String word) async {
    Uri uri = Uri.https(
      host, 
      'api/$version/entries/$language/${Uri.encodeComponent(word.toLowerCase())}'
    );
    var response = await _client.get(uri);
    if(response.statusCode == 200){
      List<dynamic> responseMap = jsonDecode(response.body);
      return responseMap.map((entry) => Entry.fromJson(entry)).toList();
    } else if (response.statusCode == 404) {
      throw DictionaryNotFoundException();
    } else {
      throw DictionaryLoadException();
    }
  }

}