import 'package:equatable/equatable.dart';

abstract class SearchDetailEvent extends Equatable {}

class FetchIssuesEvent extends SearchDetailEvent {
  FetchIssuesEvent({
    required this.ownerName,
    required this.repoName,
    this.isRefresh = false,
  });
  final String ownerName;
  final String repoName;
  final bool isRefresh;

  @override
  List<Object?> get props => [ownerName, repoName, isRefresh];
}
