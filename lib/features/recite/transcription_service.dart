import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import 'device_id.dart';
import 'recitation_exception.dart';

/// Sends a recitation to Tilawa's transcription proxy and returns the text.
///
/// The app deliberately carries no API key. The proxy holds the Deepgram
/// credential and enforces the rate limits, so limits can be tuned and abuse
/// cut off without shipping an app update.
class TranscriptionService {
  static const _path = '/v1/transcribe';

  Future<String> transcribe(File audioFile) async {
    if (transcriptionBaseUrl.isEmpty) {
      throw const RecitationException(
        'Recitation checking is not configured in this build.',
      );
    }

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(minutes: 3),
      sendTimeout: const Duration(minutes: 3),
    ));
    final bytes = await audioFile.readAsBytes();

    final Response<dynamic> response;
    try {
      response = await dio.post(
        '$transcriptionBaseUrl$_path',
        data: Stream.fromIterable([bytes]),
        options: Options(
          headers: {
            'X-Device-Id': deviceId(),
            'Content-Type': 'audio/*',
            'Content-Length': bytes.length.toString(),
          },
          responseType: ResponseType.json,
        ),
      );
    } on DioException catch (e) {
      throw RecitationException(_messageFor(e));
    }

    final data = response.data;
    if (data is Map && data['transcript'] is String) {
      return data['transcript'] as String;
    }
    return '';
  }

  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return 'No connection. Ayah Check needs the internet to score your '
            'recitation.';
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'That took too long to check. Try a shorter recording.';
      default:
        break;
    }

    final status = e.response?.statusCode;
    // The proxy already writes user-safe messages, so pass its wording through
    // where there is one rather than inventing a second vocabulary.
    final detail = e.response?.data;
    if (detail is Map && detail['detail'] is String) {
      return detail['detail'] as String;
    }
    if (status == 413) {
      return 'Recording too large. Record a single ayah at a time.';
    }
    if (status == 429) {
      return 'Too many checks just now. Wait a moment and try again.';
    }
    if (status != null && status >= 500) {
      return 'Recitation checking is having trouble. Try again shortly.';
    }
    return 'Could not check your recitation. Please try again.';
  }
}
