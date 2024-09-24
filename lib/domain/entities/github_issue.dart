import 'package:equatable/equatable.dart';

class GithubIssue extends Equatable {
  const GithubIssue({
    required this.id,
    required this.title,
    required this.number,
    required this.user,
    required this.comments,
    required this.createdAt,
  });
  final int id;
  final String title;
  final int number;
  final String user;
  final int comments;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, number, user, comments, createdAt];
}
