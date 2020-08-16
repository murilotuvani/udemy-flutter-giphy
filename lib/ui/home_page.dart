import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:udemyfluttergiphy/ui/gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offSet = 0;

  _getGifs() async {
    String url;
    if (_search == null || _search.isEmpty) {
      url ='https://api.giphy.com/v1/gifs/trending?api_key=OFCPkijwle6vt7G8lPcR2VwyOc3hTuEV&limit=25&rating=g';
    } else {
      url ='https://api.giphy.com/v1/gifs/search?api_key=OFCPkijwle6vt7G8lPcR2VwyOc3hTuEV&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en';
    }
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: _getGifs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _createGifTable(context, snapshot);
              }
            },
          ))
        ],
      ),
    );
  }

  /**
   * Caso esteja pesquisando entao deve deixar um espaço no final
   * para carregar mais gifs.
   */
  int _getCount(List data) {
    if(_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if(_search == null || _search.isEmpty || index < snapshot.data["data"].length) {
            String url =
                snapshot.data["data"][index]["images"]["fixed_height"]["url"];
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: url,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              onLongPress: () {
                print("Share : $url");
                Share.share(url);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70.0),
                    Text("Carregar mais ...",
                        style: TextStyle(color: Colors.white, fontSize: 22.0))
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offSet += 19;
                  });
                },
              ),
            );
          }
        });
  }
}
