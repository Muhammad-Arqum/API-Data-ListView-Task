import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(ApiDataListApp());

class ApiDataListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApiDataScreen(),
    );
  }
}

class ApiDataScreen extends StatefulWidget {
  @override
  _ApiDataScreenState createState() => _ApiDataScreenState();
}

class _ApiDataScreenState extends State<ApiDataScreen> {
  List _posts = [];
  List _filteredPosts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      setState(() {
        _posts = json.decode(response.body);
        _filteredPosts = _posts;
        _loading = false;
      });
    }
  }

  void _filterPosts(String query) {
    final filtered = _posts
        .where(
            (post) => post['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() => _filteredPosts = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Data with Search")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Search'),
                    onChanged: _filterPosts,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = _filteredPosts[index];
                      return ListTile(
                        title: Text(post['title']),
                        subtitle: Text(post['body']),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
