import 'package:instagram/core/models/post.dart';

abstract class HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Post> posts;
  final bool hasMore;
  HomePageLoaded({required this.posts, required this.hasMore});
}

class HomePageError extends HomePageState {
  final String message;
  HomePageError({required this.message});
}
