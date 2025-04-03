import '../../models/post.dart';
import '../../providers/user_provider.dart';
import '../../services/items_api.dart';
import './post_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadPosts{
  final List<Post> _allPosts = [];
  Future<List<Post>> loadAllPosts() async {
    final response = await ItemsApi.getAllItems();
    print(response);
    for (var item in response) {
      Post post = Post.fromJson(item);
      _allPosts.add(post);
    }
    return _allPosts;
  }
  Future<List<Post>> loadLostPosts()async{
    if(_allPosts.isNotEmpty){
      return PostFilter.filterPosts(posts: _allPosts,postType: PostType.lost);
    }else{
      await loadAllPosts();
      return PostFilter.filterPosts(posts: _allPosts,postType: PostType.lost);
    }
  }
  Future<List<Post>> loadFoundPosts()async{
    if(_allPosts.isNotEmpty){
      return PostFilter.filterPosts(posts: _allPosts,postType: PostType.found);
    }else{
      await loadAllPosts();
      return PostFilter.filterPosts(posts: _allPosts,postType: PostType.found);
    }
  }

  Future<List<Post>> loadUserLostPosts(BuildContext context)async{
    final int userId = Provider.of<UserProvider>(context,listen: false).id;
    print('userId is $userId');
    if(_allPosts.isNotEmpty){
      return PostFilter.filterPosts(posts: _allPosts,userId: userId,postType: PostType.lost);
    }else{
      await loadAllPosts();
      return PostFilter.filterPosts(posts: _allPosts,userId: userId,postType: PostType.lost);
    }
  } 

  Future<List<Post>> loadUserFoundPosts(BuildContext context)async{
    final int userId = Provider.of<UserProvider>(context,listen: false).id;
    if(_allPosts.isNotEmpty){
      return PostFilter.filterPosts(posts: _allPosts,userId: userId,postType: PostType.found);
    }else{
      await loadAllPosts();
      return PostFilter.filterPosts(posts: _allPosts,userId: userId,postType: PostType.found);
    }
  }
}