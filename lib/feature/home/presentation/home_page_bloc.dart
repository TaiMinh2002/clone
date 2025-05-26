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

  HomePageBloc(this.postService) : super(HomePageLoading()) {
    on<HomePageFetchPosts>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(
    HomePageFetchPosts event,
    Emitter<HomePageState> emit,
  ) async {
    if (!_hasMore && _skip != 0) return;
    emit(HomePageLoading());
    try {
      final posts = await postService.fetchPosts(limit: _limit, skip: _skip);
      if (posts.length < _limit) _hasMore = false;
      _posts.addAll(posts);
      _skip += _limit;
      emit(HomePageLoaded(posts: List.from(_posts), hasMore: _hasMore));
    } catch (e) {
      emit(HomePageError(message: e.toString()));
    }
  }
}
