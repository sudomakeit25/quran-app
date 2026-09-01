import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'transcription_service.dart';
import 'recitation_exception.dart';

/// Records a recitation and returns its transcript.
///
/// Shared by the single-ayah and whole-passage screens so both handle
/// permissions, temp files and cleanup identically. The recording is deleted as
/// soon as it has been transcribed.
class RecitationRecorder {
  final AudioRecorder _recorder = AudioRecorder();
  final TranscriptionService _transcription = TranscriptionService();
  String? _path;

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> start() async {
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/recitation_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _path = path;
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 64000,
      ),
      path: path,
    );
  }

  /// Stops recording, transcribes, and deletes the audio file.
  ///
  /// Throws [RecitationException] when the recording could not be captured.
  Future<String> stopAndTranscribe() async {
    final stopped = await _recorder.stop();
    final file = File(stopped ?? _path ?? '');
    if (!file.existsSync()) {
      throw const RecitationException('Recording file not found');
    }
    try {
      return await _transcription.transcribe(file);
    } finally {
      try {
        await file.delete();
      } catch (_) {
        // A leftover temp file is harmless; the OS clears the directory.
      }
    }
  }

  Future<void> cancel() async {
    try {
      await _recorder.stop();
    } catch (_) {}
    final path = _path;
    if (path == null) return;
    try {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }

  void dispose() => _recorder.dispose();
}
