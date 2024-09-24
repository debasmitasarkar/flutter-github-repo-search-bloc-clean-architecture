import 'package:equatable/equatable.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';

abstract class SearchDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchDetailInitial extends SearchDetailState {}

class SearchDetailLoading extends SearchDetailState {}

class SearchDetailLoaded extends SearchDetailState {
  final List<GithubIssue> issues;

  SearchDetailLoaded({required this.issues});

  @override
  List<Object?> get props => [issues];
}

class SearchDetailLoadingMore extends SearchDetailLoaded {
  SearchDetailLoadingMore(List<GithubIssue> issues) : super(issues: issues);

  @override
  List<Object?> get props => [issues];
}

class SearchDetailError extends SearchDetailState {
  final String message;

  SearchDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
