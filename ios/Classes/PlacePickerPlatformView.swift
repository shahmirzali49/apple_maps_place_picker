import Flutter
import UIKit
import CoreLocation
import SwiftUI

class PlacePickerPlatformView: NSObject, FlutterPlatformView {
    private var placePickerViewController: PlacePickerViewController?
    private var methodChannel: FlutterMethodChannel?
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger) {
        super.init()
        
        let params = args as? [String: Any]
        let initialLat = params?["initialLatitude"] as? Double ?? 0.0
        let initialLng = params?["initialLongitude"] as? Double ?? 0.0
        let initialLocation = CLLocationCoordinate2D(latitude: initialLat, longitude: initialLng)
        
        let config = params?["config"] as? [String: Any]
        
        methodChannel = FlutterMethodChannel(name: "place_picker/\(viewId)", binaryMessenger: messenger)
        
        placePickerViewController = PlacePickerViewController(
            initialLocation: initialLocation,
            config: config,
            onPlaceSelected: { [weak self] place in
                let placeData = place.toDictionary
                self?.methodChannel?.invokeMethod("onPlaceSelected", arguments: placeData)
            },
            onLocationUpdated: { [weak self] place in
                let placeData = place.toDictionary
                self?.methodChannel?.invokeMethod("onLocationUpdated", arguments: placeData)
            },
             onSearchStateChanged: { [weak self] isPresented in
                           self?.methodChannel?.invokeMethod("onSearchStateChanged", arguments: isPresented)
                       }
        )
    }
    
    func view() -> UIView {
        return placePickerViewController?.view ?? UIView()
    }
}
