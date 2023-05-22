import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
      methodCount: 3, // number of method calls to be displayed
      errorMethodCount: 5, // number of method calls if stacktrace is provided
      lineLength: 80, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true // Shouch log print contain a timestamp
      ),
);

void initLogs() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    logger.e('Error caught by Flutter', [details.exception, details.stack]);
  };
}


void log(dynamic exception, StackTrace? stack) {
  // Logging the error
  logger.e('Error', [exception, stack]);
}

void printf(dynamic exception) {
  // Logging the error
  logger.i('INFO', [exception]);
}

void printV(dynamic exception) {
  // Logging the error
  logger.v('VERBOSE', [exception]);
}