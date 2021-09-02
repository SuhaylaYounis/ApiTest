import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'PostModels.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var responsebody;

  @override
  void initState() {
    this.getposts();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Posts List",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getposts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Card(
                        child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("id: ${snapshot.data[i].id} "),
                          Text("userId: ${snapshot.data[i].userId} "),
                          Text("body: ${snapshot.data[i].body} "),
                          Text("title: ${snapshot.data[i].title} "),
                        ],
                      ),
                    ));
                  },
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
          }),
    );
  }

  //to get the items in the link and store it and async it
  Future<List<PostModels>> getposts() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    //for it to be asynchronized so that id data in data base changed it will sync the change
    var response = await http.get(url);
    List<PostModels> postList = [];
    //check if code is working
    if (response.statusCode == 200) {
     var responsebody = jsonDecode(response.body);
      for (var i in responsebody) {
        PostModels x = PostModels(
            userId: i["userId"],
            id: i["id"],
            title: i["title"],
            body: i["body"]);
        postList.add((x));
      }
    }
    return postList;
  }
}
