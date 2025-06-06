import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post.dart';
import 'package:instagram/core/services/post_service.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PostService postService;
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  final List<Post> _posts = [];
  final Map<int, int> _commentCounts = {};
  final Set<int> _likedPosts = {};

  HomePageBloc(this.postService) : super(HomePageLoading()) {
    on<HomePageFetchPosts>(_onFetchPosts);
    on<HomePageToggleLike>(_onToggleLike);
  }

  Future<void> _onFetchPosts(
    HomePageFetchPosts event,
    Emitter<HomePageState> emit,
  ) async {
    if (!_hasMore && _skip != 0) return;
    if (_skip == 0) emit(HomePageLoading());
    try {
      final posts = await postService.fetchPosts(limit: _limit, skip: _skip);
      if (posts.length < _limit) _hasMore = false;
      _posts.addAll(posts);
      for (final post in posts) {
        if (!_commentCounts.containsKey(post.id)) {
          final (_, total) = await postService.fetchCommentsByPostId(post.id);
          _commentCounts[post.id] = total;
        }
      }
      _skip += _limit;
      emit(
        HomePageLoaded(
          posts: List.from(_posts),
          hasMore: _hasMore,
          commentCounts: Map.from(_commentCounts),
          likedPosts: _likedPosts,
        ),
      );
    } catch (e) {
      emit(HomePageError(message: e.toString()));
    }
  }

  void _onToggleLike(HomePageToggleLike event, Emitter<HomePageState> emit) {
    if (state is HomePageLoaded) {
      final currentState = state as HomePageLoaded;
      final newLikedPosts = Set<int>.from(currentState.likedPosts);

      if (newLikedPosts.contains(event.postId)) {
        newLikedPosts.remove(event.postId);
      } else {
        newLikedPosts.add(event.postId);
      }

      emit(currentState.copyWith(likedPosts: newLikedPosts));
    }
  }
}
