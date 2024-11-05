import 'package:flutter/foundation.dart';

extension TargetPlatformX on TargetPlatform {
  bool get isIOS => this == TargetPlatform.iOS;
}