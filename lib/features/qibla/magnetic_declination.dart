import 'dart:math' as math;

/// Approximate magnetic declination using the Earth's dipole model.
///
/// Returns degrees east of true north (positive = magnetic east of true,
/// negative = magnetic west of true). Apply as:
///   true_heading = magnetic_heading + declination
///
/// Accuracy: ~5–10° depending on location. The Earth's field has higher-order
/// terms (especially in polar regions and the South Atlantic Anomaly) that
/// this approximation does not capture. For navigation use cases this is
/// sufficient; for survey-grade work, use the full WMM.
double magneticDeclination(double observerLat, double observerLng) {
  // North magnetic pole position (drifts; values for ~2025).
  // Source: NOAA WMM 2025.
  const poleLat = 86.0;
  const poleLng = 160.0;

  final phi1 = observerLat * math.pi / 180;
  final phi2 = poleLat * math.pi / 180;
  final dLambda = (poleLng - observerLng) * math.pi / 180;

  final y = math.sin(dLambda) * math.cos(phi2);
  final x = math.cos(phi1) * math.sin(phi2) -
      math.sin(phi1) * math.cos(phi2) * math.cos(dLambda);

  final bearingRad = math.atan2(y, x);
  var bearingDeg = bearingRad * 180 / math.pi;

  // Normalize to (-180, 180] so the result reads naturally as +east / -west.
  if (bearingDeg > 180) bearingDeg -= 360;
  if (bearingDeg <= -180) bearingDeg += 360;
  return bearingDeg;
}
