import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gitData;

  GifPage(this._gitData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gitData["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              String url = _gitData["images"]["fixed_height"]["url"];
              print("Share : $url");
              Share.share(url);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gitData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
