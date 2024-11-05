// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apple_maps_place_picker/src/models/style_models.dart';
import 'package:flutter/material.dart';

class PlacePickerConfig {
  final SearchBarConfig? searchBarConfig;
  final AddressViewConfig? addressViewConfig;
  final CenterMarkerConfig? centerMarkerConfig;
  final SearchResultConfig? searchResultConfig;

  const PlacePickerConfig({
    this.searchBarConfig,
    this.addressViewConfig,
    this.centerMarkerConfig,
    this.searchResultConfig,
  });

  Map<String, dynamic> toMap() {
    return {
      'searchBarConfig': searchBarConfig?.toMap(),
      'addressViewConfig': addressViewConfig?.toMap(),
      'centerMarkerConfig': centerMarkerConfig?.toMap(),
      'searchResultConfig': searchResultConfig?.toMap(),
    };
  }
}

class SearchBarConfig {
  final String? hintText;
  final Color? leadingIconColor;
  final TextStyle? textFieldTextStyle;
  final Color? textFieldBackgroundColor;
  final PaddingModel? padding;
  final Color? backgroundColor;
  final String? cancelButtonText;
  final Color? cancelButtonTextColor;

  const SearchBarConfig({
    this.hintText,
    this.leadingIconColor,
    this.textFieldTextStyle,
    this.textFieldBackgroundColor,
    this.padding,
    this.backgroundColor,
    this.cancelButtonText,
    this.cancelButtonTextColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'hintText': hintText,
      'leadingIconColor': leadingIconColor?.value,
      'textFieldTextStyle': textFieldTextStyle != null
          ? {
              'fontSize': textFieldTextStyle!.fontSize,
              'fontWeight': textFieldTextStyle!.fontWeight?.toString(),
              'foregroundColor': textFieldTextStyle!.color?.value,
            }
          : null,
      'textFieldBackgroundColor': textFieldBackgroundColor?.value,
      'padding': padding?.toMap(),
      'backgroundColor': backgroundColor?.value,
      'cancelButtonText': cancelButtonText,
      'cancelButtonTextColor': cancelButtonTextColor?.value,
    };
  }
}

class AddressViewConfig {
  final PaddingModel? addressPadding;
  final Color? backgroundColor;
  final TextStyle? addressTextStyle;
  final ButtonStyleModel? confirmButtonStyle;
  final String? confirmButtonText;
  final String? unkownAddressText;
  final String? notFoundAddressText;

  const AddressViewConfig({
    this.addressPadding,
    this.backgroundColor,
    this.addressTextStyle,
    this.confirmButtonStyle,
    this.confirmButtonText,
    this.unkownAddressText,
    this.notFoundAddressText,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressPadding': addressPadding?.toMap(),
      'backgroundColor': backgroundColor?.value,
      'addressTextStyle': {
        'fontSize': addressTextStyle?.fontSize,
        'fontWeight': addressTextStyle?.fontWeight?.toString(),
        'foregroundColor': addressTextStyle?.color?.value,
      },
      'confirmButtonStyle': {
        'backgroundColor': confirmButtonStyle?.backgroundColor?.value,
        'cornerRadius': confirmButtonStyle?.cornerRadius,
        'textStyle': {
          'fontSize': confirmButtonStyle?.textStyle?.fontSize,
          'fontWeight': confirmButtonStyle?.textStyle?.fontWeight?.toString(),
          'foregroundColor': confirmButtonStyle?.textStyle?.color?.value,
        },
        'padding': confirmButtonStyle?.padding?.toMap(),
      },
      'confirmButtonText': confirmButtonText,
      'unkownAddressText': unkownAddressText,
      'notFoundAddressText': notFoundAddressText,
    };
  }
}

class CenterMarkerConfig {
  final Color? markerColor;
  final double? markerSize;

  const CenterMarkerConfig({
    this.markerColor,
    this.markerSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'markerColor': markerColor?.value,
      'markerSize': markerSize,
    };
  }
}

class SearchResultConfig {
  final TextStyle? itemTextStyle;
  final PaddingModel? itemPadding;
  final PaddingModel? itemMargin;
  final Color? itemBackgroundColor;
  final Color? backgroundColor;

  const SearchResultConfig({
    this.itemTextStyle,
    this.itemPadding,
    this.itemMargin,
    this.itemBackgroundColor,
    this.backgroundColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemTextStyle': {
        'fontSize': itemTextStyle?.fontSize,
        'fontWeight': itemTextStyle?.fontWeight?.toString(),
        'foregroundColor': itemTextStyle?.color?.value,
      },
      'itemPadding': itemPadding?.toMap(),
      'itemMargin': itemMargin?.toMap(),
      'itemBackgroundColor': itemBackgroundColor?.value,
      'backgroundColor': backgroundColor?.value,
    };
  }
}
