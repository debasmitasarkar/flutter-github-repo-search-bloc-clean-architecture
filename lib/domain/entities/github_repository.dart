import 'package:equatable/equatable.dart';

class GithubRepository extends Equatable {
  const GithubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.ownerAvatarUrl,
    required this.ownerName,
    this.description,
    required this.size,
    required this.stargazersCount,
    required this.forksCount,
    this.license,
    required this.openIssuesCount,
  });
  final int id;
  final String name;
  final String fullName;
  final String ownerName;
  final String ownerAvatarUrl;
  final String? description;
  final int size;
  final int stargazersCount;
  final int forksCount;
  final String? license;
  final int openIssuesCount;

  @override
  List<Object?> get props => [id];
}
