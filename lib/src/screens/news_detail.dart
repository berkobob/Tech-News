import 'package:flutter/material.dart';
import '../widgets/comment.dart';
import '../models/item.dart';
import '../blocs/comments_provider.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail(this.itemId);

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<Item>>> snapshot) {
        if (!snapshot.hasData) return Text('Loading');
        final itemFuture = snapshot.data[itemId];
        return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<Item> itemSnapshot) {
              if (!snapshot.hasData) return Text('Loading');
              return buildList(itemSnapshot.data, snapshot.data);
            });
      },
    );
  }

  Widget buildList(Item item, Map<int, Future<Item>> itemMap){
    final commentsList = item.kids.map((kidId){
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList();

    return ListView(children: <Widget>[
      buildTitle(item.title),
      ...commentsList,
    ],);
  }

  buildTitle(String title) {
    return Container(
      // width: double.infinity,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
