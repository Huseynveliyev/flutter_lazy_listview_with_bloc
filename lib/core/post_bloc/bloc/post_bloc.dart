import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lazy_listview_with_bloc/core/exception/exception.dart';
import 'package:flutter_lazy_listview_with_bloc/core/model/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
part 'post_event.dart';
part 'post_state.dart';

typedef HttpClient = http.Client;
const _postLimit = 10;

const Duration _postDuration = Duration(milliseconds: 100);

EventTransformer<T> postDroppable<T>(Duration duration) {
  return (events, mapper) {
    return droppable<T>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required HttpClient client})
      : _client = client,
        super(const PostState()) {
    on<PostFechEvent>(
      _onPostFetched,
      transformer: postDroppable(_postDuration),
    );
  }

  final HttpClient _client;

  Future<void> _onPostFetched(
      PostFechEvent event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      if (state.status == PostStatus.inital) {
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: PostStatus.success,
          hasReachedMax: false,
          posts: posts,
        ));
      }
      final posts = await _fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts)));
    } catch (_) {
      emit(
        state.copyWith(
          status: PostStatus.failure,
        ),
      );
    }
  }

  Future<List<PostModel>> _fetchPosts([startIndex = 0]) async {
    final response = await _client.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        {
          '_start': '$startIndex',
          '_limit': '$_postLimit',
        },
      ),
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((dynamic posts) => PostModel.fromJson(JsonMap.from(posts)))
          .cast<PostModel>()
          .toList();
    }
    throw PostException(
      error: response.body,
    );
  }
}
