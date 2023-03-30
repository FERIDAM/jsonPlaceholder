import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class Post {
  int userId;
  int id;
  String title;
  String body;

  Post({required this.userId, required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }
}

class _MyAppState extends State<MyApp> {
  List<Post> _posts = [];
  bool _isLoading = true;

  Future<void> _fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        _isLoading = false;
        _posts = jsonData.map((post) => Post.fromJson(post)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Placeholder Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Placeholder Demo'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _posts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 2),
                itemBuilder: (BuildContext context, int index) {
                  final post = _posts[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(post.title),
                        SizedBox(height: 10),
                        Text(post.body),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
