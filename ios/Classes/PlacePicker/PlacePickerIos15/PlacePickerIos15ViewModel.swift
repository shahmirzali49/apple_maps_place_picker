
import SwiftUI
import MapKit
import Combine
import Flutter

class PlacePickerIos15ViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var currentPlace: Place?
    @Published var searchText: String = ""
    @Published var searchState: SearchState = .initial
    @Published var visibleRegion: MKCoordinateRegion?
    
    @Published var shouldPerformSearch = true
    private var defaultRegion: MKCoordinateRegion
    private var cancellables = Set<AnyCancellable>()
    private let geocoder = CLGeocoder()
    private let searchDebounceTime: TimeInterval = 0.7
    private let onLocationUpdated: (Place) -> Void
    
 
    init(initialLocation: CLLocationCoordinate2D, onLocationUpdated: @escaping (Place) -> Void) {
        self.defaultRegion = MKCoordinateRegion(
            center: initialLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.region = self.defaultRegion
        self.onLocationUpdated = onLocationUpdated
        setupSearchPublisher()
        
         $currentPlace
             .compactMap { $0 }
             .sink { [weak self] place in
                 self?.onLocationUpdated(place)
             }
             .store(in: &cancellables)
    }
    
    
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: .seconds(searchDebounceTime), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self, self.shouldPerformSearch else { return }
                if searchText.isEmpty {
                    self.searchState = .initial
                } else {
                    self.searchState = .searching
                    self.searchPlaces(query: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchPlaces(query: String) {
        guard !query.isEmpty else {
            self.searchState = .initial
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = visibleRegion ?? defaultRegion
        
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Search error: \(error)")
                    self.searchState = .notFound
                    return
                }
                
                guard let response = response else {
                    self.searchState = .notFound
                    return
                }
                
                let places = response.mapItems.compactMap { (item: MKMapItem) -> Place? in
                    guard let name = item.name ?? item.placemark.title,
                          item.placemark.coordinate.latitude.isFinite,
                          item.placemark.coordinate.longitude.isFinite else {
                        return nil
                    }
                    
                    let placemark = item.placemark
                    let address = [
                        placemark.thoroughfare,
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.postalCode,
                        placemark.country
                    ].compactMap { $0 }.joined(separator: ", ")
                    
                    return Place(
                        name: name,
                        address: address,
                        coordinate: item.placemark.coordinate
                    )
                }
                
                if places.isEmpty {
                    self.searchState = .notFound
                } else {
                    self.searchState = .found(places)
                }
            }
        }
    }
    
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) async {
        // Validate coordinates
        guard coordinate.latitude.isFinite && coordinate.longitude.isFinite,
              coordinate.latitude >= -90 && coordinate.latitude <= 90,
              coordinate.longitude >= -180 && coordinate.longitude <= 180 else {
            await MainActor.run {
                self.currentPlace = nil
            }
            return
        }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                let address = [
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                await MainActor.run {
                    self.currentPlace = Place(
                        name: placemark.name ?? "Unnamed Place",
                        address: address,
                        coordinate: coordinate
                    )
                }
            }
        } catch {
            print("Geocoding error: \(error)")
            await MainActor.run {
                self.currentPlace = nil
            }
        }
    }
    
    func selectPlace(_ place: Place) {
        guard place.coordinate.latitude.isFinite && place.coordinate.longitude.isFinite else {
            return
        }
        
        region = MKCoordinateRegion(
            center: place.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        searchState = .initial
        searchText = ""
        onLocationUpdated(place)
    }
    
    func updateRegion(_ newRegion: MKCoordinateRegion) {
        guard newRegion.center.latitude.isFinite && newRegion.center.longitude.isFinite,
              newRegion.span.latitudeDelta.isFinite && newRegion.span.longitudeDelta.isFinite else {
            return
        }
        
        visibleRegion = newRegion
        Task { @MainActor in
            await reverseGeocode(coordinate: newRegion.center)
        }
    }
}
