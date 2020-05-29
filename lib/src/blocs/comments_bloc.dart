import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/item.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _repository = Respository();
  final _commentsOutput = BehaviorSubject<Map<int, Future<Item>>>();

  // Streams
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // Sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  Stream<Map<int, Future<Item>>> get itemWithComments => _commentsOutput.stream;

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }

  StreamTransformer<int, Map<int, Future<Item>>> _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<Item>>>(
        (cache, int id, index) {
      print(index);
      cache[id] = _repository.fetchItem(id);
      cache[id].then(
        (Item item) {
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        },
      );
      return cache;
    }, <int, Future<Item>>{});
  }
}
