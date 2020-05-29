import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/loading_container.dart';
import '../models/item.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<Item>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<Item> snapshot) {
          if (!snapshot.hasData) return LoadingContainer();

          final item = snapshot.data;
          final children = <Widget>[
            ListTile(
              title: Html(
                data: item.text,
                onLinkTap: (url) async => await launch(url),
                ),
              subtitle: item.by == "" ? Text('Deleted') : Text(item.by),
              contentPadding: EdgeInsets.only(right: 16, left: (depth * 16.0)),
            ),
            Divider(),
          ];

          item.kids.forEach((kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              ),
            );
          });

          return Column(
            children: children,
          );
        });
  }
}
