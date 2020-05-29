import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/widgets/loading_container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/item.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<Item>>> snapshot) {
        if (!snapshot.hasData) return LoadingContainer();
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<Item> itemSnapshot) {
            if (!itemSnapshot.hasData) return LoadingContainer();
            return buildTile(context, itemSnapshot.data);
          }
        );
      }
    );
  }

  Widget buildTile(BuildContext context, Item item){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          subtitle: Text('${item.score} points'),
          trailing: Column(children: <Widget>[
            Icon(Icons.comment),
            Text('${item.descendants}')
          ],),
          onTap: () => Navigator.pushNamed(context, '/${item.id}'),
          // onTap: () => _launchURL(item.url),
        ),
        Divider(height: 8),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}