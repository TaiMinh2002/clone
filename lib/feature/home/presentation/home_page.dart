import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/models/post.dart';
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
      create: (_) => HomePageBloc(PostService())..add(HomePageFetchPosts()),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(AssetIcons.logosInstagram, height: 32),
        actions: [
          Row(
            children: [
              SvgPicture.asset(AssetIcons.addFavorite),
              SvgPicture.asset(AssetIcons.notification),
              SvgPicture.asset(AssetIcons.message),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          if (state is HomePageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomePageLoaded) {
            return ListView.builder(
              itemCount: state.hasMore
                  ? state.posts.length + 1
                  : state.posts.length,
              itemBuilder: (context, index) {
                if (index == state.posts.length) {
                  // Load more
                  return TextButton(
                    onPressed: () =>
                        context.read<HomePageBloc>().add(HomePageFetchPosts()),
                    child: const Text('Load more'),
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
                    // Expanded(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           SvgPicture.asset(AssetIcons.favorite),
                    //           SvgPicture.asset(AssetIcons.comment),
                    //           SvgPicture.asset(AssetIcons.share),
                    //         ],
                    //       ),
                    //       SvgPicture.asset(AssetIcons.addFavorite),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '${post.views} views',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
    // return ListTile(
    //   leading: CircleAvatar(
    //     backgroundImage: NetworkImage(
    // 'https://randomuser.me/api/portraits/men/${post.userId % 100}.jpg',
    //     ),
    //   ),
    //   title: Text('User có id là ${post.userId}'),
    //   trailing: const Icon(Icons.more_vert),
    // );
    return Row(
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
      ],
    );
  }
}
