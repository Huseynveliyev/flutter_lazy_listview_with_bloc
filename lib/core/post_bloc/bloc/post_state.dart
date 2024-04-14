part of 'post_bloc.dart';

enum PostStatus { inital, progress, success, failure }

class PostState extends Equatable {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final PostStatus status;

  const PostState(
      {this.posts = const <PostModel>[],
      this.hasReachedMax = false,
      this.status = PostStatus.inital});

  @override
  List<Object> get props => [posts, hasReachedMax, status];

  PostState copyWith(
      {List<PostModel>? posts, bool? hasReachedMax, PostStatus? status}) {
    return PostState(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status);
  }
}
