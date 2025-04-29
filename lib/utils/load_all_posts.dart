import 'dart:convert';

import 'package:final_project/providers/all_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/user_provider.dart';
import '../../services/items_api.dart';
import './post_filter.dart';

class LoadPosts {
  final List<Post> _allPosts = [];
  
  Future<List<Post>> loadAllPosts(BuildContext context) async {
    final response = await ItemsApi.getAllItems();
    print('response data is');
    final responseData = jsonDecode(response.body)['posts'];
    print(responseData);
    // print(responseData[0]);

    for (var item in responseData) {
      Post post = await Post.fromJson(item);
      print(post.imageProvider);
      _allPosts.add(post);
    }
    context.read<AllItemsProvider>().updateData(_allPosts);
    print(Provider.of<AllItemsProvider>(context,listen: false).allPosts);
    
    return _allPosts;
  }

  Future<List<Post>> loadLostPosts(BuildContext context) async {
    if (_allPosts.isNotEmpty) {
      return PostFilter.filterPosts(posts: _allPosts, postType: PostType.lost);
    } else {
      // if(Provider.of<AllItemsProvider>(context,listen: false).allPosts.isNotEmpty){
      //   _allPosts = Provider.of<AllItemsProvider>(context,listen: false).allPosts;
      //   return PostFilter.filterPosts(posts: _allPosts, postType: PostType.lost);
      // }
      await loadAllPosts(context);
      return PostFilter.filterPosts(posts: _allPosts, postType: PostType.lost);
    }
  }

  Future<List<Post>> loadFoundPosts(BuildContext context) async {
    if (_allPosts.isNotEmpty) {
      return PostFilter.filterPosts(posts: _allPosts, postType: PostType.found);
    } else {
      // if(Provider.of<AllItemsProvider>(context,listen: false).allPosts.isNotEmpty){
      //   _allPosts = Provider.of<AllItemsProvider>(context,listen: false).allPosts;
      //   return PostFilter.filterPosts(posts: _allPosts, postType: PostType.found);
      // }
      await loadAllPosts(context);
      return PostFilter.filterPosts(posts: _allPosts, postType: PostType.found);

    }
  }

  Future<List<Post>> loadUserLostPosts(BuildContext context) async {
    final int userId = Provider.of<UserProvider>(context, listen: false).id;
    print('userId is $userId');
    if (_allPosts.isNotEmpty) {
      return PostFilter.filterPosts(
          posts: _allPosts, userId: userId, postType: PostType.lost);
    } else {
      // if(Provider.of<AllItemsProvider>(context,listen: false).allPosts.isNotEmpty){
      //   _allPosts = Provider.of<AllItemsProvider>(context,listen: false).allPosts;
      //   return PostFilter.filterPosts(
      //     posts: _allPosts, userId: userId, postType: PostType.lost);
      // }
      await loadAllPosts(context);
      return PostFilter.filterPosts(
          posts: _allPosts, userId: userId, postType: PostType.lost);
    }
  }

  Future<List<Post>> loadUserFoundPosts(BuildContext context) async {
    final int userId = Provider.of<UserProvider>(context, listen: false).id;
    if (_allPosts.isNotEmpty) {
      return PostFilter.filterPosts(
          posts: _allPosts, userId: userId, postType: PostType.found);
    } else {
      // if(Provider.of<AllItemsProvider>(context,listen: false).allPosts.isNotEmpty){
      //   _allPosts = Provider.of<AllItemsProvider>(context,listen: false).allPosts;
      //   return PostFilter.filterPosts(
      //     posts: _allPosts, userId: userId, postType: PostType.found);
      // }
      await loadAllPosts(context);
      return PostFilter.filterPosts(
          posts: _allPosts, userId: userId, postType: PostType.found);
    }
  }

  Future<List<Post>> loadReportedPosts(BuildContext context) async{
    if (_allPosts.isNotEmpty) {
      return PostFilter.filterPosts(posts: _allPosts, reports: 1);
    }else{
      // if(Provider.of<AllItemsProvider>(context,listen: false).allPosts.isNotEmpty){
      //   _allPosts = Provider.of<AllItemsProvider>(context,listen: false).allPosts;
      //   return PostFilter.filterPosts(posts: _allPosts, reports: 1);
      // }
      await loadAllPosts(context);
      return PostFilter.filterPosts(posts: _allPosts, reports: 1);
    }
  }
}
