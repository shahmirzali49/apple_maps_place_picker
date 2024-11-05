import 'package:flutter/widgets.dart';

class ButtonStyleModel {
  final Color? backgroundColor;
  final double? cornerRadius;
  final TextStyle? textStyle;
  final PaddingModel? padding;

  const ButtonStyleModel({
    this.backgroundColor,
    this.cornerRadius,
    this.textStyle,
    this.padding,
  });

  @override
  String toString() =>
      'ButtonStyleModel(backgroundColor: ${backgroundColor?.value}, cornerRadius: $cornerRadius, padding: $padding)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'backgroundColor': backgroundColor?.value,
      'cornerRadius': cornerRadius,
      'textStyle': {
        'fontSize': textStyle?.fontSize,
        'fontWeight': textStyle?.fontWeight?.toString(),
        'foregroundColor': textStyle?.color?.value,
      },
      'padding': padding?.toMap(),
    };
  }
}

class PaddingModel {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const PaddingModel({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
    };
  }

  // Method to create padding with vertical and horizontal symmetrical values
  factory PaddingModel.symmetric({double? vertical, double? horizontal}) {
    return PaddingModel(
      left: horizontal,
      right: horizontal,
      top: vertical,
      bottom: vertical,
    );
  }

  // Method to create padding with the same value on all sides
  factory PaddingModel.all(double value) {
    return PaddingModel(
      left: value,
      top: value,
      right: value,
      bottom: value,
    );
  }

  factory PaddingModel.fromMap(Map<String, dynamic> map) {
    return PaddingModel(
      left: map['left'] != null ? map['left'] as double : null,
      top: map['top'] != null ? map['top'] as double : null,
      right: map['right'] != null ? map['right'] as double : null,
      bottom: map['bottom'] != null ? map['bottom'] as double : null,
    );
  }
}