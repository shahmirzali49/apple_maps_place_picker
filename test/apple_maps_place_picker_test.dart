// import 'package:flutter_test/flutter_test.dart';
// import 'package:apple_maps_place_picker/apple_maps_place_picker.dart';
// import 'package:apple_maps_place_picker/apple_maps_place_picker_platform_interface.dart';
// import 'package:apple_maps_place_picker/apple_maps_place_picker_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockAppleMapsPlacePickerPlatform
//     with MockPlatformInterfaceMixin
//     implements AppleMapsPlacePickerPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final AppleMapsPlacePickerPlatform initialPlatform = AppleMapsPlacePickerPlatform.instance;

//   test('$MethodChannelAppleMapsPlacePicker is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAppleMapsPlacePicker>());
//   });

//   test('getPlatformVersion', () async {
//     AppleMapsPlacePicker appleMapsPlacePickerPlugin = AppleMapsPlacePicker();
//     MockAppleMapsPlacePickerPlatform fakePlatform = MockAppleMapsPlacePickerPlatform();
//     AppleMapsPlacePickerPlatform.instance = fakePlatform;

//     expect(await appleMapsPlacePickerPlugin.getPlatformVersion(), '42');
//   });
// }
