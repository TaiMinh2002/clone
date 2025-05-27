abstract class HomePageEvent {}

class HomePageFetchPosts extends HomePageEvent {}

class HomePageToggleLike extends HomePageEvent {
  final int postId;
  HomePageToggleLike(this.postId);
}
