import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart ' as http;
import 'package:jsonwork/models/posts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // fetching data from Api
  Future<List<Post>> fetchPost() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<Post> myListPosts = [];

      var data = jsonDecode(response.body);

      for (Map i in data) {
        myListPosts.add(Post.fromMap(i as Map<String, dynamic>));
      }

      print(myListPosts);

      return myListPosts;
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Post.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Work',
      home: Scaffold(
        backgroundColor: Color(0xffcdb4db),
        appBar: AppBar(
          title: Text("Json Simple Work"),
        ),
        body: FutureBuilder<List<Post>>(
          future: fetchPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  // crossAxisSpacing: 5.0,
                  // mainAxisSpacing: ,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GridTile(
                            
                            child: Container(
                              child: Text(
                                "id:${snapshot.data![index].id}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GridTile(
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "Title: ${snapshot.data![index].title}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GridTile(
                            child: Container(
                              height: 200,
                              child: Text(
                                  "Description: ${snapshot.data![index].body}"),
                              decoration: BoxDecoration(
                                color: Color(0xfff4a261),
                                border:
                                    Border.all(color: Colors.black, width: 0.5),
                              ),
                            ),
                          ),
                                                    Divider(color: Colors.black,height: 40,thickness: 2.0),

                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
