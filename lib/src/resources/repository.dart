import 'package:news/src/resources/news_api_provider.dart';
import 'package:news/src/resources/news_db_provider.dart';

import '../models/item.dart';

class Respository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[newsDbProvider];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<Item> fetchItem(int id) async {

    Item item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) break;
    }

    for (var cache in caches) cache.addItem(item);

    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<Item> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(Item item);
}
