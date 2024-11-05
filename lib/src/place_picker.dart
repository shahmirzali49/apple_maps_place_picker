import 'package:apple_maps_place_picker/apple_maps_place_picker.dart';
import 'package:apple_maps_place_picker/src/extensions/platform_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class AppleMapsPlacePicker extends StatefulWidget {
  /// Initial latitude for the place picker
  final double initialLatitude;

  /// Initial longitude for the place picker
  final double initialLongitude;

  /// Configuration options for customizing the place picker UI
  final PlacePickerConfig? config;

  /// Callback function when a place is selected
  final Function(Place)? onPlaceSelected;

  /// Custom bottom address view widget builder
  final Widget Function(Place?)? customBottomAddressViewBuilder;

  /// Custom marker widget to replace the default marker
  final Widget? customMarker;

  AppleMapsPlacePicker({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    this.config,
    this.onPlaceSelected,
    this.customBottomAddressViewBuilder,
    this.customMarker,
  })  : assert(
          (config?.centerMarkerConfig ?? false) == false ||
              customMarker == null,
          'Either use the customMarker or config\'s center marker, not both.',
        ),
        assert(
          (config?.addressViewConfig ?? true) == false ||
              customBottomAddressViewBuilder == null,
          'Either use customBottomAddressViewBuilder or config\'s address view, not both.',
        );

  @override
  State<AppleMapsPlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<AppleMapsPlacePicker> {
  final ValueNotifier<Place?> _currentPlace = ValueNotifier<Place?>(null);
  final ValueNotifier<bool> _isSearchPresented = ValueNotifier<bool>(false);
  MethodChannel? _channel;

  @override
  void dispose() {
    _currentPlace.dispose();
    _isSearchPresented.dispose();
    super.dispose();
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'onPlaceSelected':
          if (call.arguments is Map) {
            final placeData = Map<String, dynamic>.from(call.arguments as Map);
            final place = Place.fromMap(placeData);
            widget.onPlaceSelected?.call(place);
          }
          break;

        case 'onLocationUpdated':
          if (call.arguments is Map) {
            final placeData = Map<String, dynamic>.from(call.arguments as Map);
            final place = Place.fromMap(placeData);
            _currentPlace.value = place;
          }
          break;

        case 'onSearchStateChanged':
          if (call.arguments is bool) {
            _isSearchPresented.value = call.arguments as bool;
          }
          break;

        default:
          debugPrint('Unhandled method call: ${call.method}');
          break;
      }
    } catch (e, stackTrace) {
      debugPrint('Error handling method call ${call.method}: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Map<String, dynamic> get _creationParams => {
        'initialLatitude': widget.initialLatitude,
        'initialLongitude': widget.initialLongitude,
        'config': {
          if (widget.config != null) ...widget.config!.toMap(),
          'showAddressView': widget.customBottomAddressViewBuilder == null,
          'showDefaultCenterMarker': widget.customMarker == null,
        },
      };

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('place_picker/$id');
    _channel?.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Widget build(BuildContext context) {
    if (!defaultTargetPlatform.isIOS) {
      // Unsupported platform message
      return const Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
          ),
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              'Platform not supported\n\nApple Maps Place Picker is only available on iOS devices.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: UiKitView(
            viewType: 'place_picker_view',
            creationParams: _creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
            hitTestBehavior: PlatformViewHitTestBehavior.translucent,
          ),
        ),
        if (widget.customMarker != null)
          ValueListenableBuilder<bool>(
            valueListenable: _isSearchPresented,
            builder: (context, isSearchPresented, child) {
              if (isSearchPresented) return const SizedBox.shrink();
              return Center(
                child: PointerInterceptor(
                  child: widget.customMarker!,
                ),
              );
            },
          ),
        if (widget.customMarker != null)
          ValueListenableBuilder<bool>(
            valueListenable: _isSearchPresented,
            builder: (context, isSearchPresented, child) {
              if (isSearchPresented) return const SizedBox.shrink();
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<Place?>(
                  valueListenable: _currentPlace,
                  builder: (context, value, _) {
                    return PointerInterceptor(
                      child: widget.customBottomAddressViewBuilder!(value),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
