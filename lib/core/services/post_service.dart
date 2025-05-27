import 'package:dio/dio.dart';
import 'package:instagram/core/models/comment.dart';
import 'package:instagram/core/models/post.dart';

class PostService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  Future<List<Post>> fetchPosts({int limit = 10, int skip = 0}) async {
    // ignore: inference_failure_on_function_invocation
    final response = await _dio.get(
      '/posts',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    // ignore: avoid_dynamic_calls
    final data = response.data['posts'] as List;
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<(List<Comment>, int)> fetchCommentsByPostId(int postId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await _dio.get('/comments/post/$postId');
    final data = response.data;
    // ignore: avoid_dynamic_calls
    final comments = (data['comments'] as List)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
    // ignore: avoid_dynamic_calls
    final total = data['total'] as int;
    return (comments, total);
  }
}
