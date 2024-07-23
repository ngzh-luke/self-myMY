import 'package:logger/logger.dart';
import 'dart:io' as io;

// logger.d("Logger is working!");

class LogHelper extends LogOutput {
  static var logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 85, // Width of the output
      colors: io.stdout.supportsAnsiEscapes, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      logger.i(line);
    }
  }
}
