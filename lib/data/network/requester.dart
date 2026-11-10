import 'package:dio/dio.dart';

class Requester {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type':'application/json'}
    )
  );

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw RequestException(_messageFor(e));
    }
  }

  Future<dynamic> post(String path, {dynamic body}) async {
    try{
      final response = await _dio.post(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw RequestException(_messageFor(e));
    }
  }

  Future<dynamic> put(String path, {dynamic body}) async {
    try {
      final response = await _dio.put(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw RequestException(_messageFor(e));
    }
  }
  
  Future<dynamic> patch(String path, {dynamic body}) async {
    try {
      final response = await _dio.patch(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw RequestException(_messageFor(e));
    }
  }

  Future<dynamic> delete(String path, {dynamic body}) async {
    try {
      final response = await _dio.delete(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw RequestException(_messageFor(e));
    }
  }

  Future<List<int>> getBytes(String path) async {
    try {
      final response = await _dio.get<List<int>>(
        path,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? [];
    } on DioException catch (e) {
      throw RequestException(_messageFor(e));
    }
  }

  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'O servidor demorou para responder.';
      
      case DioExceptionType.connectionError:
        return 'Não foi possivel conectar ao servidor';
      
      case DioExceptionType.badResponse:
        return _messageFromBody(e.response) ??
          'O servidor recusou o pedido '
            '(código ${e.response?.statusCode}).';


      default:
        return 'Erro inesperado na requisição.';
    }
  }

  String? _messageFromBody(Response? response) {
  final data = response?.data;

  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }

  if (data is String) {
    return data;
  }

  return null;
  }
}

class RequestException implements Exception {
  final String message;

  RequestException(this.message);

  @override
  String toString() => message;
}