import SwiftUI
import MapKit
import Combine

// MARK: - Map Coordinator
class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewRepresentable
    
    init(_ parent: MapViewRepresentable) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let newRegion = mapView.region
        if parent.region.isSignificantlyDifferent(from: newRegion) {
            // print("newRegion \(newRegion)")
            parent.onRegionChange(mapView.region)
            }
       
    }
}

// MARK: - UIKit Map View Representative
struct MapViewRepresentable: UIViewRepresentable {
    let region: MKCoordinateRegion
    let onRegionChange: (MKCoordinateRegion) -> Void
    @State private var isFirstLoad = true // State variable to track the first load
    
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        mapView.setRegion(region, animated: true)
//        return mapView
//    }
    
    
       func makeUIView(context: Context) -> MKMapView {
           let mapView = MKMapView()
           mapView.delegate = context.coordinator
           mapView.setRegion(region, animated: true)
           
           // Call onRegionChange immediately on first load
           if isFirstLoad {
               context.coordinator.parent.onRegionChange(region) // Trigger initial callback
               isFirstLoad = false // Set to false to prevent future calls
           }

           return mapView
       }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
}
