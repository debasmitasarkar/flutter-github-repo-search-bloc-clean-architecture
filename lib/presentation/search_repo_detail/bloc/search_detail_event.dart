import 'package:equatable/equatable.dart';

abstract class SearchDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchIssuesEvent extends SearchDetailEvent {
  final String ownerName;
  final String repoName;
  final bool isRefresh;
  final int page;

  FetchIssuesEvent({
    required this.ownerName,
    required this.repoName,
    this.isRefresh = false,
    this.page = 1,
  });

  @override
  List<Object?> get props => [ownerName, repoName, isRefresh, page];
}
