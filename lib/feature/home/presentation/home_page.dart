import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/models/post.dart';
import 'package:instagram/core/services/locator.dart';
import 'package:instagram/core/services/post_service.dart';
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8,
                        children: post.tags
                            .map(
                              (tag) => Chip(
                                label: Text('#$tag'),
                                backgroundColor: Colors.grey[200],
                              ),
                            )
                            .toList(),
                      ),
                    ),
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
    final commentCount =
        (context
                .findAncestorWidgetOfExactType<
                  BlocBuilder<HomePageBloc, HomePageState>
                >()
                ?.builder !=
            null)
        ? (context.findAncestorStateOfType<_HomePageViewState>()?.widget.key !=
                  null
              ? 0
              : 0)
        : 0;
    final state = context.read<HomePageBloc>().state;
    int count = 0;
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
          SvgPicture.asset(AssetIcons.comment),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: Text('$count'),
          ),
          SvgPicture.asset(AssetIcons.share),
          const Spacer(),
          SvgPicture.asset(AssetIcons.addFavorite),
        ],
      ),
    );
  }

  Widget _descriptionWidget(Post post) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 30, bottom: 10),
      child: _ExpandableText(title: post.title, body: post.body),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String title;
  final String body;
  const _ExpandableText({required this.title, required this.body});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;
  bool _isOverflow = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.body, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        _isOverflow = tp.didExceedMaxLines;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: _isOverflow
                  ? () => setState(() => _expanded = !_expanded)
                  : null,
              child: _expanded || !_isOverflow
                  ? Text(widget.body, style: textStyle)
                  : Text.rich(
                      TextSpan(
                        text: widget.body,
                        style: textStyle,
                        children: [
                          const TextSpan(text: '...'),
                          TextSpan(
                            text: 'more',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        );
      },
    );
  }
}
