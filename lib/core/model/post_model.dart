import 'package:equatable/equatable.dart';

typedef JsonMap = Map<String, dynamic>;

class PostModel extends Equatable {
  final int id;
  final String title;
  final String body;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(JsonMap json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
  @override
  List<Object?> get props => [id, title, body];
}
