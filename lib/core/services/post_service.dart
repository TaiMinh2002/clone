import 'package:dio/dio.dart';
import '../models/post.dart';

class PostService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  Future<List<Post>> fetchPosts({int limit = 10, int skip = 0}) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    final data = response.data['posts'] as List;
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }
}
