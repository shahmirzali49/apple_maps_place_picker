import Flutter
import UIKit


public class AppleMapsPlacePickerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = PlacePickerViewFactory(messenger: registrar.messenger())
    registrar.register(
      factory,
      withId: "place_picker_view"
    )
  }
}