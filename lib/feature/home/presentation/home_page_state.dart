import 'package:instagram/core/models/post.dart';

abstract class HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Post> posts;
  final bool hasMore;
  final Map<int, int> commentCounts;
  final Set<int> likedPosts;

  HomePageLoaded({
    required this.posts,
    required this.hasMore,
    required this.commentCounts,
    this.likedPosts = const {},
  });

  HomePageLoaded copyWith({
    List<Post>? posts,
    bool? hasMore,
    Map<int, int>? commentCounts,
    Set<int>? likedPosts,
  }) {
    return HomePageLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      commentCounts: commentCounts ?? this.commentCounts,
      likedPosts: likedPosts ?? this.likedPosts,
    );
  }
}

class HomePageError extends HomePageState {
  final String message;
  HomePageError({required this.message});
}
