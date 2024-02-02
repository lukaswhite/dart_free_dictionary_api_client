import 'package:dictionary_api/api.dart';
import 'package:dictionary_api/models/entry.dart';
import 'package:dictionary_api/models/meanings.dart';
import 'package:dictionary_api/models/phonetics.dart';
import 'package:dictionary_api/models/definitions.dart';
import 'package:dictionary_api/models/license.dart';
import 'package:dictionary_api/exceptions/dictionary_load_exception.dart';
import 'package:dictionary_api/exceptions/dictionary_not_found_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import './dictionary_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('lookup', () async {
    const jsonString = r'[{"word":"hello","phonetics":[{"audio":"https://api.dictionaryapi.dev/media/pronunciations/en/hello-au.mp3","sourceUrl":"https://commons.wikimedia.org/w/index.php?curid=75797336","license":{"name":"BY-SA 4.0","url":"https://creativecommons.org/licenses/by-sa/4.0"}},{"text":"/həˈləʊ/","audio":"https://api.dictionaryapi.dev/media/pronunciations/en/hello-uk.mp3","sourceUrl":"https://commons.wikimedia.org/w/index.php?curid=9021983","license":{"name":"BY 3.0 US","url":"https://creativecommons.org/licenses/by/3.0/us"}},{"text":"/həˈloʊ/","audio":""}],"meanings":[{"partOfSpeech":"noun","definitions":[{"definition":"\"Hello!\" or an equivalent greeting.","synonyms":[],"antonyms":[]}],"synonyms":["greeting"],"antonyms":[]},{"partOfSpeech":"verb","definitions":[{"definition":"To greet with \"hello\".","synonyms":[],"antonyms":[]}],"synonyms":[],"antonyms":[]},{"partOfSpeech":"interjection","definitions":[{"definition":"A greeting (salutation) said when meeting someone or acknowledging someone’s arrival or presence.","synonyms":[],"antonyms":[],"example":"Hello, everyone."},{"definition":"A greeting used when answering the telephone.","synonyms":[],"antonyms":[],"example":"Hello? How may I help you?"},{"definition":"A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.","synonyms":[],"antonyms":[],"example":"Hello? Is anyone there?"},{"definition":"Used sarcastically to imply that the person addressed or referred to has done something the speaker or writer considers to be foolish.","synonyms":[],"antonyms":[],"example":"You just tried to start your car with your cell phone. Hello?"},{"definition":"An expression of puzzlement or discovery.","synonyms":[],"antonyms":[],"example":"Hello! What’s going on here?"}],"synonyms":[],"antonyms":["bye","goodbye"]}],"license":{"name":"CC BY-SA 3.0","url":"https://creativecommons.org/licenses/by-sa/3.0"},"sourceUrls":["https://en.wiktionary.org/wiki/hello"]}]';

    final client = MockClient();

    final api = DictionaryApi(client);

    when(client
      .get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/hello')))
      .thenAnswer((_) async =>
        http.Response(jsonString, 200, headers: {'content-type': 'application/json; charset=utf-8'}));

    List<Entry> entries = await api.lookup('hello');

    expect(await api.lookup('hello'), isA<List<Entry>>());

    expect(entries.length, 1);
    expect(entries[0], isA<Entry>());
    expect(entries[0].word, 'hello');

    Entry hello = entries[0];
    expect(hello.word, 'hello');
    expect(hello.sourceUrls, isA<List<String>>());
    expect(hello.sourceUrls?[0], isA<String>());
    expect(hello.sourceUrls?[0], 'https://en.wiktionary.org/wiki/hello');
    expect(hello.license, isA<License>());
    expect(hello.license?.name, 'CC BY-SA 3.0');
    expect(hello.license?.url, 'https://creativecommons.org/licenses/by-sa/3.0');

    expect(hello.phonetics.runtimeType, List<Phonetics>);
    expect(hello.phonetics?[0], isA<Phonetics>());
    expect(hello.phonetics?[0].text, null);
    expect(hello.phonetics?[0].audio, 'https://api.dictionaryapi.dev/media/pronunciations/en/hello-au.mp3');
    expect(hello.phonetics?[0].sourceUrl, 'https://commons.wikimedia.org/w/index.php?curid=75797336');
    expect(hello.phonetics?[0].license, isA<License>());
    expect(hello.phonetics?[0].license?.name, 'BY-SA 4.0');
    expect(hello.phonetics?[0].license?.url, 'https://creativecommons.org/licenses/by-sa/4.0');
    
    expect(hello.phonetics?[1], isA<Phonetics>());
    expect(hello.phonetics?[1].text, '/həˈləʊ/');
    expect(hello.phonetics?[1].audio, 'https://api.dictionaryapi.dev/media/pronunciations/en/hello-uk.mp3');

    expect(hello.meanings, isA<List<Meanings>>());
    expect(hello.meanings?.length, 3);
    expect(hello.meanings?[0], isA<Meanings>());
    expect(hello.meanings?[0].partOfSpeech, 'noun');
    expect(hello.meanings?[0].synonyms, isA<List>());
    expect(hello.meanings?[0].synonyms?.length, 1);
    expect(hello.meanings?[0].synonyms?[0], 'greeting');
    expect(hello.meanings?[0].antonyms, isA<List>());
    expect(hello.meanings?[0].antonyms?.length, 0);
    expect(hello.meanings?[0].definitions, isA<List<Definitions>>());
    expect(hello.meanings?[0].definitions?[0].definition, '"Hello!" or an equivalent greeting.');
    expect(hello.meanings?[0].definitions?[0].synonyms, isA<List>());
    expect(hello.meanings?[0].definitions?[0].synonyms?.length, 0);
    expect(hello.meanings?[0].definitions?[0].antonyms, isA<List>());
    expect(hello.meanings?[0].definitions?[0].antonyms?.length, 0);

    expect(hello.meanings?[2].partOfSpeech, 'interjection');
    expect(hello.meanings?[2].antonyms?.length, 2);
    expect(hello.meanings?[2].antonyms?[0], 'bye');
    expect(hello.meanings?[2].antonyms?[1], 'goodbye');
    expect(hello.meanings?[2].definitions?[0].example, 'Hello, everyone.');
    
  });

  test('not found', () async {
    
    const jsonString = r'{"title":"No Definitions Found","message":"Sorry pal, we couldn\t find definitions for the word you were looking for.","resolution":"You can try the search again at later time or head to the web instead."}';
    final client = MockClient();

    final api = DictionaryApi(client);

    when(client
      .get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/dhfuhdijuhfjjsbdjfsd')))
      .thenAnswer((_) async =>
        http.Response(jsonString, 404, headers: {'content-type': 'application/json; charset=utf-8'}));

    expect(() => api.lookup('dhfuhdijuhfjjsbdjfsd'), throwsA(isA<DictionaryNotFoundException>()));
    
  });

  test('other error', () async {
    
    final client = MockClient();

    final api = DictionaryApi(client);

    when(client
      .get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/hello')))
      .thenAnswer((_) async =>
        http.Response('Server Error', 500, headers: {'content-type': 'text/html; charset=utf-8'}));

    expect(() => api.lookup('hello'), throwsA(isA<DictionaryLoadException>()));
    
  });

}
