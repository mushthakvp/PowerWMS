import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

void initLogs() {
  LogsConfig config = LogsConfig()
    ..isDebuggable = true
    ..customClosingDivider = "|"
    ..customOpeningDivider = "|"
    ..csvDelimiter = ", "
    ..encryptionEnabled = false
    ..encryptionKey = ""
    ..formatType = FormatType.FORMAT_CURLY
    ..logLevelsEnabled = [LogLevel.INFO, LogLevel.ERROR]
    ..dataLogTypes = [
      DataLogType.DEFAULT.toString(),
      DataLogType.DEVICE.toString(),
      DataLogType.NETWORK.toString(),
      DataLogType.ERRORS.toString(),
    ]
    ..timestampFormat = TimestampFormat.TIME_FORMAT_READABLE;
  FLog.applyConfigurations(config);
  FLog.clearLogs();

  FlutterError.onError = (FlutterErrorDetails details) async {
    log(details.exception, details.stack);
  };
}

void log(Object exception, StackTrace? stack) {
  FLog.error(
    dataLogType: DataLogType.DEFAULT.toString(),
    exception: exception,
    stacktrace: stack,
    text: DateTime.now().toString(),
  );
}