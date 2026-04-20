import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

/// Render [child] offscreen to a PNG and share it.
Future<void> shareAyahAsImage({
  required BuildContext context,
  required int surahNumber,
  required int ayahNumber,
  required String surahName,
  required String arabic,
  required String? translation,
}) async {
  final card = _AyahCard(
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    surahName: surahName,
    arabic: arabic,
    translation: translation,
  );

  final bytes = await _renderWidgetToPng(card, const Size(1080, 1080));
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/ayah_${surahNumber}_$ayahNumber.png');
  await file.writeAsBytes(bytes);

  final text = translation == null
      ? 'Quran $surahNumber:$ayahNumber'
      : '"$translation"\n\n— Quran $surahNumber:$ayahNumber';
  await Share.shareXFiles(
    [XFile(file.path)],
    text: text,
    subject: '$surahName $surahNumber:$ayahNumber',
  );
}

Future<Uint8List> _renderWidgetToPng(Widget widget, Size size) async {
  final repaintBoundary = RenderRepaintBoundary();
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final pipelineOwner = PipelineOwner();
  final buildOwner = BuildOwner(focusManager: FocusManager());

  final renderView = RenderView(
    view: view,
    configuration: ViewConfiguration(
      physicalConstraints: BoxConstraints.tight(size),
      logicalConstraints: BoxConstraints.tight(size),
      devicePixelRatio: 1.0,
    ),
    child: RenderPositionedBox(
      alignment: Alignment.center,
      child: repaintBoundary,
    ),
  );

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: Directionality(textDirection: TextDirection.ltr, child: widget),
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();
  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final image = await repaintBoundary.toImage(pixelRatio: 2.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

class _AyahCard extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String arabic;
  final String? translation;

  const _AyahCard({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.arabic,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 1080,
        height: 1080,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F766E), Color(0xFF064E3B)],
          ),
        ),
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$surahName  ·  $surahNumber:$ayahNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 32,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                arabic,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 54,
                  height: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
            if (translation != null) ...[
              const SizedBox(height: 32),
              Text(
                '"$translation"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 48),
            const Text(
              'Quran & Prayer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
