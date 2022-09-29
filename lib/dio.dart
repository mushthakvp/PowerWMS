import 'package:dio/dio.dart';

var dio = Dio();

class Failure {
  final String message;

  const Failure(this.message);
}

class NoConnection extends Failure {
  const NoConnection(String message) : super(message);
}