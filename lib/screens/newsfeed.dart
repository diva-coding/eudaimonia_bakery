import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/news.dart';
import 'package:eudaimonia_bakery/services/data_services.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  Future<List<News>>? _news;
  @override
  void initState() {
    super.initState();
    _news = DataService.fetchNews();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<News>>(
        future: _news,
        builder: ((context, snapshot) {
          if (snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          } else if (snapshot.hasError){
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        }),
      ),
    );
  }
}