import 'dart:convert';

import 'package:appunidad34/models/Gif.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<List<Gif>> _listadoGifs = _getGifs();

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=SnMo7c426ryFGuaoi3ZL9nPz3Z9b5LCm&limit=10&rating=g"));

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var i in jsonData["data"]) {
        gifs.add(Gif(i["title"], i["images"]["downsized"]["url"]));
      }
 //ola
      return gifs;

    } else {
      throw Exception("Falló la conexion");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _listadoGifs;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Future/Http'),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listGifs(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listGifs(data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(
        Card(
            child: Column(
          children: [
            Expanded(
              child: Image.network(
                gif.url,
                fit: BoxFit.fill,
              ),
            ),
          ],
        )),
      );
    }
    return gifs;
  }
}
