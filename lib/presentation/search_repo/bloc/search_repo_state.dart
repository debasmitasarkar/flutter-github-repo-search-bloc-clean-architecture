import 'package:equatable/equatable.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';

abstract class SearchRepoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchRepoInitial extends SearchRepoState {}

class SearchRepoLoading extends SearchRepoState {}

class SearchRepoLoaded extends SearchRepoState {
  final List<GithubRepository> repositories;

  SearchRepoLoaded({required this.repositories});

  @override
  List<Object?> get props => [repositories];
}

class SearchRepoLoadingMore extends SearchRepoLoaded {
  SearchRepoLoadingMore(List<GithubRepository> repositories)
      : super(repositories: repositories);
}

class SearchError extends SearchRepoState {
  final String message;

  SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
