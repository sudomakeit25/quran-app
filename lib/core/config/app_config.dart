/// Where Ayah Check sends recordings for transcription.
///
/// This is a plain URL, not a secret: the app holds no API key. The Deepgram
/// key lives only on the proxy (see `server/` in this repo), so it cannot be
/// pulled out of the IPA and cannot be spent against by anyone who unpacks the
/// app.
///
/// Override per build with:
///   flutter build ipa --dart-define=TILAWA_API_BASE=https://your-host
const transcriptionBaseUrl = String.fromEnvironment(
  'TILAWA_API_BASE',
  // Render derives the hostname from the service name in render.yaml. Confirm
  // this against the dashboard after the first deploy; Render appends a suffix
  // when the name is already taken.
  defaultValue: 'https://tilawa-transcribe.onrender.com',
);
