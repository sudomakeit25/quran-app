import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'magnetic_declination.dart';

const _defaultCoords = (lat: 21.4225, lng: 39.8262);

final _coordsProvider = FutureProvider<({double lat, double lng})>((ref) async {
  try {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return _defaultCoords;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return _defaultCoords;
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 15),
    );
    return (lat: pos.latitude, lng: pos.longitude);
  } catch (_) {
    return _defaultCoords;
  }
});

final _useCompassProvider = StateProvider<bool>((_) => true);

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordsAsync = ref.watch(_coordsProvider);
    final useCompass = ref.watch(_useCompassProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF3F4F3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B3A2A),
        foregroundColor: Colors.white,
        title: const Text('Qibla Direction'),
        centerTitle: true,
      ),
      body: coordsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white)),
        error: (e, _) =>
            Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        data: (coords) {
          final qiblaBearing =
              Qibla(Coordinates(coords.lat, coords.lng)).direction;
          final declination = magneticDeclination(coords.lat, coords.lng);
          return _Body(
            coords: coords,
            qiblaBearing: qiblaBearing,
            declination: declination,
            useCompass: useCompass,
            onToggle: (v) => ref.read(_useCompassProvider.notifier).state = v,
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ({double lat, double lng}) coords;
  final double qiblaBearing;
  final double declination;
  final bool useCompass;
  final ValueChanged<bool> onToggle;

  const _Body({
    required this.coords,
    required this.qiblaBearing,
    required this.declination,
    required this.useCompass,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopRow(
          coords: coords,
          qiblaBearing: qiblaBearing,
          useCompass: useCompass,
          onToggle: onToggle,
        ),
        Expanded(
          child: useCompass
              ? StreamBuilder<CompassEvent?>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    final magneticHeading = snapshot.data?.heading ?? 0;
                    final trueHeading =
                        ((magneticHeading + declination) % 360 + 360) % 360;
                    final relative =
                        ((qiblaBearing - trueHeading) % 360 + 360) % 360;
                    final aligned = relative < 5 || relative > 355;
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: _CompassDial(
                              rotationDeg: -trueHeading,
                              qiblaBearing: qiblaBearing,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: aligned
                                ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                                : Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _Readout(
                                label: 'Heading',
                                value: '${trueHeading.toStringAsFixed(0)}°',
                              ),
                              _Readout(
                                label: 'Qibla',
                                value:
                                    '${qiblaBearing.toStringAsFixed(0)}°',
                              ),
                              _Readout(
                                label: 'Turn',
                                value: aligned
                                    ? '✓ Aligned'
                                    : relative < 180
                                        ? '${relative.toStringAsFixed(0)}° →'
                                        : '← ${(360 - relative).toStringAsFixed(0)}°',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: _CompassDial(
                    rotationDeg: -qiblaBearing,
                    qiblaBearing: qiblaBearing,
                  ),
                ),
        ),
      ],
    );
  }
}

class _TopRow extends StatelessWidget {
  final ({double lat, double lng}) coords;
  final double qiblaBearing;
  final bool useCompass;
  final ValueChanged<bool> onToggle;

  const _TopRow({
    required this.coords,
    required this.qiblaBearing,
    required this.useCompass,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final dir = qiblaBearing <= 180 ? 'east' : 'west';
    final shown = qiblaBearing <= 180 ? qiblaBearing : 360 - qiblaBearing;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => GoRouter.of(context).push('/prayer'),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/prayer_rug.png',
                    width: 56,
                    height: 56,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.access_time, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Prayer\nTimes',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12, height: 1.1),
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 56, color: Colors.white24),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  '${coords.lat.toStringAsFixed(2)}°, ${coords.lng.toStringAsFixed(2)}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${shown.toStringAsFixed(1)} degrees $dir of north.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 56, color: Colors.white24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: useCompass,
                  onChanged: onToggle,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF22C55E),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Use\ncompass',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Readout extends StatelessWidget {
  final String label;
  final String value;
  const _Readout({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _CompassDial extends StatelessWidget {
  /// Degrees to rotate the dial (cardinal letters and ticks rotate too).
  final double rotationDeg;
  /// Qibla bearing relative to true north (always shows kaaba in correct direction on the dial).
  final double qiblaBearing;

  const _CompassDial({
    required this.rotationDeg,
    required this.qiblaBearing,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Transform.rotate(
          angle: rotationDeg * math.pi / 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: _DialPainter(),
              ),
              // Kaaba + Prayer rug in a single column, rotated together
              // toward the qibla bearing. Kaaba is at the top (mihrab end).
              Transform.rotate(
                angle: qiblaBearing * math.pi / 180,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final dialSize =
                        math.min(constraints.maxWidth, constraints.maxHeight);
                    final rugHeight = dialSize * 0.55;
                    final rugWidth = rugHeight * 0.55;
                    return SizedBox(
                      width: rugWidth,
                      height: rugHeight + 70, // room for kaaba above
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🕋', style: TextStyle(fontSize: 48)),
                          SizedBox(
                            width: rugWidth,
                            height: rugHeight,
                            child: Image.asset(
                              'assets/icon/prayer_rug.png',
                              fit: BoxFit.fill,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.crop_portrait,
                                      size: 100, color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Offset _offsetForBearing(double bearingDeg, double fractionOfRadius) {
    // Approximate offset based on widget size; LayoutBuilder would be more accurate
    final rad = bearingDeg * math.pi / 180;
    const r = 280.0 * 0.9; // approximate inner radius
    return Offset(math.sin(rad) * r * fractionOfRadius,
        -math.cos(rad) * r * fractionOfRadius);
  }
}

class _DialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2;
    final outer = r;
    final inner = r - 8;

    // Outer dark ring
    canvas.drawCircle(
      c,
      outer,
      Paint()..color = const Color(0xFF6B7568),
    );
    // White face
    canvas.drawCircle(c, inner, Paint()..color = Colors.white);

    // Tick marks
    final tickPaintMajor = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final tickPaintMinor = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 60; i++) {
      final ang = i * 6 * math.pi / 180 - math.pi / 2;
      final isMajor = (i % 5 == 0) && ((i ~/ 5) % 1 == 0);
      // 12 majors total (every 30°), of those, alternating green/gray
      final isCardinalArea = i % 15 != 0; // not on N/E/S/W
      final useGreen = isMajor && isCardinalArea;
      final p = useGreen ? tickPaintMajor : tickPaintMinor;
      final tickLen = useGreen ? 22.0 : (isMajor ? 14.0 : 8.0);
      final p1 = c + Offset(math.cos(ang), math.sin(ang)) * (inner - 8);
      final p2 = c + Offset(math.cos(ang), math.sin(ang)) * (inner - 8 - tickLen);
      canvas.drawLine(p1, p2, p);
    }

    // Cardinal letters (with perspective skew look — stylized italic)
    const letters = ['N', 'E', 'S', 'W'];
    for (var i = 0; i < 4; i++) {
      final ang = i * math.pi / 2 - math.pi / 2;
      final pos = c + Offset(math.cos(ang), math.sin(ang)) * (inner - 50);
      final tp = TextPainter(
        text: TextSpan(
          text: letters[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) => false;
}
