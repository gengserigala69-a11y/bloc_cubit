import 'package:flutter/material.dart';
import 'package:bloc_cubit/posts/view/posts_list.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PostsList();
  }
}