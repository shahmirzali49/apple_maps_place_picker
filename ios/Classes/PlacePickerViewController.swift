import SwiftUI
import UIKit
import Flutter
import CoreLocation

class PlacePickerViewController: UIViewController {
    private var placePickerView: UIHostingController<AnyView>?
    private var onPlaceSelected: ((Place) -> Void)?
    private var onLocationUpdated: ((Place) -> Void)?
    private var initialLocation: CLLocationCoordinate2D?
    private var config: [String: Any]?
    private var onSearchStateChanged: ((Bool) -> Void)?
    
    init(initialLocation: CLLocationCoordinate2D?, config: [String: Any]?, onPlaceSelected: @escaping (Place) -> Void, 
    onLocationUpdated: @escaping (Place) -> Void,
    onSearchStateChanged: @escaping (Bool) -> Void
    ) {
        self.initialLocation = initialLocation
        self.config = config
        self.onPlaceSelected = onPlaceSelected
        self.onLocationUpdated = onLocationUpdated
        self.onSearchStateChanged = onSearchStateChanged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlacePicker()
    }
    
    private func setupPlacePicker() {
        let rootView: AnyView
        
        if #available(iOS 17.0, *) {
            rootView = AnyView(PlacePickerIos17View(
                initialLocation: initialLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
                config: config,
                onPlaceSelected: { [weak self] place in
                    self?.onPlaceSelected?(place)
                },
                onLocationUpdated: { [weak self] place in
                    self?.onLocationUpdated?(place)
                },
                onSearchStateChanged: { [weak self] isPresent in
                    self?.onSearchStateChanged?(isPresent)
                }
            ))
        } else {
            rootView = AnyView(PlacePickerIos15View(
                initialLocation: initialLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
                config: config,
                onPlaceSelected: { [weak self] place in
                    self?.onPlaceSelected?(place)
                },
                onLocationUpdated: { [weak self] place in
                    self?.onLocationUpdated?(place)
                },
                onSearchStateChanged: { [weak self] isPresent in
                    self?.onSearchStateChanged?(isPresent)
                }
            ))
        }
        
        placePickerView = UIHostingController(rootView: rootView)
        
        if let placePickerView = placePickerView {
            addChild(placePickerView)
            view.addSubview(placePickerView.view)
            placePickerView.view.frame = view.bounds
            placePickerView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            placePickerView.didMove(toParent: self)
        }
    }
}
