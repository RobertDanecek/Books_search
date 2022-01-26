import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class descriptionScreen extends StatelessWidget {
  final Map data;

  const descriptionScreen({Key? key, required this.data}) : super(key: key);

  Widget oneRow(String ID, context) {
    try {
      if (data[ID].length>0) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: Text(
                    ID + ':',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 180 - 20,
                  child: Text(
                    data[ID],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ));
      }
      else
        return Container();
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
        body: Center(
            child: ListView(children: <Widget>[
      Column(
        children: [
          SizedBox(height: 20),
          Image.network(data['image']),
          oneRow('title', context),
          oneRow('subtitle', context),
          oneRow('authors', context),
          oneRow('publisher', context),
          oneRow('pages', context),
          oneRow('price', context),
          oneRow('year', context),
          oneRow('isbn10', context),
          oneRow('isbn13', context),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: InkWell(
                onTap: (() {
                  launch(data['url']);
                }),
                child: Text(
                  data['url'],
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back')),
        ],
      )
    ])));
  }
}
