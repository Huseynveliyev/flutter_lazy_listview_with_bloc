part of 'post_bloc.dart';

@immutable
sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

@immutable
class PostFechEvent extends PostEvent {
  const PostFechEvent();
}
