# Dictionary API Client

A Dart/Flutter client for the [Free Dictionary API](https://dictionaryapi.dev/).

## Getting started

todo

## Usage

Create an instance and provide an HTTP client, e.g.:

```dart
import 'package:http/http.dart' as http;

import 'package:dictionary_api/dictionary_api.dart';

final api = DictionaryApi(http.Client());
```

Look up a word in the dictionary with:

```dart
List<Entry> = api.lookup('hello');
```
