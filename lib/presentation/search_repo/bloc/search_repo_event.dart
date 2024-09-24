import 'package:equatable/equatable.dart';

abstract class SearchRepoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRepositories extends SearchRepoEvent {
  final String searchQuery;
  final bool isRefresh;
  final int currentPage;

  FetchRepositories({
    required this.searchQuery,
    this.isRefresh = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [searchQuery, isRefresh];
}
