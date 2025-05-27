import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/models/comment.dart';
import 'package:instagram/core/models/post.dart';
import 'package:instagram/core/services/locator.dart';
import 'package:instagram/core/services/post_service.dart';
import 'package:instagram/core/widgets/text_input_widget.dart';
import 'package:instagram/feature/home/presentation/components/body_text.dart';
import 'package:instagram/feature/home/presentation/home_page_bloc.dart';
import 'package:instagram/feature/home/presentation/home_page_event.dart';
import 'package:instagram/feature/home/presentation/home_page_state.dart';
import 'package:instagram/r.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomePageBloc(locator<PostService>())..add(HomePageFetchPosts()),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      final bloc = context.read<HomePageBloc>();
      final state = bloc.state;
      if (state is HomePageLoaded && state.hasMore) {
        _isLoadingMore = true;
        bloc.add(HomePageFetchPosts());
        Future.delayed(const Duration(milliseconds: 500), () {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(AssetIcons.logosInstagram, height: 32),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(AssetIcons.addFeed),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SvgPicture.asset(AssetIcons.notification),
                ),
                SvgPicture.asset(AssetIcons.message),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          if (state is HomePageLoading && (state is! HomePageLoaded)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomePageLoaded) {
            return ListView.builder(
              key: const PageStorageKey('home_list'),
              controller: _scrollController,
              itemCount: state.hasMore
                  ? state.posts.length + 1
                  : state.posts.length,
              itemBuilder: (context, index) {
                if (index == state.posts.length && state.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final post = state.posts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _avatarWidget(post),
                    Image.network(
                      'https://picsum.photos/400/400?random=${post.id}',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    _actionWidget(post),
                    _descriptionWidget(post),
                    _tagsWidget(post),
                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          } else if (state is HomePageError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _avatarWidget(Post post) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 24, bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/${post.userId % 100}.jpg',
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('User có id là ${post.userId}'),
          ),
          const Spacer(),
          SvgPicture.asset(AssetIcons.settingPost),
        ],
      ),
    );
  }

  Widget _actionWidget(Post post) {
    final state = context.read<HomePageBloc>().state;
    var count = 0;
    if (state is HomePageLoaded) {
      count = state.commentCounts[post.id] ?? 0;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 30, bottom: 10, top: 10),
      child: Row(
        children: [
          SvgPicture.asset(AssetIcons.favorite),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: Text('${post.views}'),
          ),
          GestureDetector(
            onTap: () => _showCommentsBottomSheet(context, post.id),
            child: Row(
              children: [
                SvgPicture.asset(AssetIcons.comment),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10),
                  child: Text('$count'),
                ),
              ],
            ),
          ),
          SvgPicture.asset(AssetIcons.share),
          const Spacer(),
          SvgPicture.asset(AssetIcons.addFavorite),
        ],
      ),
    );
  }

  Future<void> _showCommentsBottomSheet(
    BuildContext context,
    int postId,
  ) async {
    // ignore: inference_failure_on_function_invocation
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: FutureBuilder<(List<Comment>, int)>(
            future: locator<PostService>().fetchCommentsByPostId(postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Lỗi khi tải comment'));
              }
              final comments = snapshot.data?.$1 ?? [];
              if (comments.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Chưa có comment nào'),
                  ),
                );
              }
              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final cmt = comments[index];
                          return _commentWidget(cmt);
                        },
                      ),
                    ),
                    const Spacer(),
                    TextInputWidget(
                      controller: _commentController,
                      hintText: 'Thêm comment',
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _descriptionWidget(Post post) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 30, bottom: 10),
      child: BodyText(title: post.title, body: post.body),
    );
  }

  Widget _tagsWidget(Post post) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 30, bottom: 10),
      child: Wrap(
        spacing: 8,
        children: post.tags.map((tag) => Chip(label: Text('#$tag'))).toList(),
      ),
    );
  }

  Widget _commentWidget(Comment cmt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/${cmt.user.id % 100}.jpg',
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cmt.user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Text(
                      cmt.body,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Text('Trả lời'),
                ],
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AssetIcons.favorite),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('${cmt.likes}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
