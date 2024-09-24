import 'package:equatable/equatable.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';

abstract class SearchRepoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchRepoInitial extends SearchRepoState {}

class SearchRepoLoading extends SearchRepoState {}

class SearchRepoLoaded extends SearchRepoState {
  SearchRepoLoaded({required this.repositories});
  final List<GithubRepository> repositories;

  @override
  List<Object?> get props => [repositories];
}

class SearchRepoLoadingMore extends SearchRepoLoaded {
  SearchRepoLoadingMore(List<GithubRepository> repositories)
      : super(repositories: repositories);
}

class SearchError extends SearchRepoState {
  SearchError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
