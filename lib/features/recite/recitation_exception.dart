/// A recitation check failure with a message safe to show the user.
///
/// Lives in its own file so the recorder and the transcription service can both
/// use it without importing each other.
class RecitationException implements Exception {
  final String message;
  const RecitationException(this.message);
  @override
  String toString() => message;
}
