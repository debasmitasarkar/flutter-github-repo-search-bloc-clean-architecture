import 'package:equatable/equatable.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';

abstract class SearchDetailState extends Equatable {}

class SearchDetailInitial extends SearchDetailState {
  @override
  List<Object?> get props => [];
}

class SearchDetailLoaded extends SearchDetailState {
  SearchDetailLoaded({required this.issues});
  final List<GithubIssue> issues;

  @override
  List<Object?> get props => [issues];
}

class SearchDetailLoadingMore extends SearchDetailLoaded {
  SearchDetailLoadingMore(List<GithubIssue> issues) : super(issues: issues);

  @override
  List<Object?> get props => [issues];
}

class SearchDetailError extends SearchDetailState {
  SearchDetailError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
