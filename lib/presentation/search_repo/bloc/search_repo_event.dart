import 'package:equatable/equatable.dart';

abstract class SearchRepoEvent extends Equatable {}

class FetchRepositories extends SearchRepoEvent {
  FetchRepositories({
    required this.searchQuery,
    this.isRefresh = false,
  });
  final String searchQuery;
  final bool isRefresh;

  @override
  List<Object?> get props => [searchQuery, isRefresh];
}
