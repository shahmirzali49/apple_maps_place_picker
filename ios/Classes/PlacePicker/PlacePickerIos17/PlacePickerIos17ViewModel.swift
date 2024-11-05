

import SwiftUI
import MapKit
import Combine
import Flutter

@available(iOS 17.0, *)
@MainActor
class PlacePickerIos17ViewModel: ObservableObject {
    @Published var camera: MapCameraPosition
    @Published var currentPlace: Place?
    @Published var searchText: String = ""
    @Published var searchState: SearchState = .initial
    @Published var visibleRegion: MKCoordinateRegion?
    
    @Published var shouldPerformSearch: Bool = true
    private var defaultRegion: MKCoordinateRegion!
    private var cancellables = Set<AnyCancellable>()
    private let geocoder = CLGeocoder()
    private let searchDebounceTime: TimeInterval = 0.7
    private let onLocationUpdated: (Place) -> Void
    
     
    
     init(initialLocation: CLLocationCoordinate2D, onLocationUpdated: @escaping (Place) -> Void) {
         currentPlace = Place(name: "", address: "", coordinate: initialLocation)
         self.defaultRegion = MKCoordinateRegion(
            center: initialLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.camera = .region(defaultRegion)
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
                    // print("shouldPerformSearch \(String(describing: self?.shouldPerformSearch))")
                    guard let self = self, self.shouldPerformSearch else { return }
                    Task { @MainActor in
                        if searchText.isEmpty {
                            self.searchState = .initial
                        } else {
                            // print("Search \(searchText)")
                            self.searchState = .searching
                            await self.searchPlaces(query: searchText)
                        }
                    }
                }
                .store(in: &cancellables)
        }

    func searchPlaces(query: String) async {
        guard !query.isEmpty else {
            self.searchState = .initial
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        // Enhanced search region with wider span
        let widerSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let searchRegion = MKCoordinateRegion(
            center: visibleRegion?.center ?? defaultRegion.center,
            span: widerSpan
        )
        request.region = searchRegion
        
        // Configure search parameters for more results
        request.resultTypes = [.pointOfInterest, .address]
        
        do {
            // Perform two searches sequentially with error handling
            var allPlaces: [Place] = []
            
            // Search 1: Standard search
            if let places = try await performSearch(request: request) {
                allPlaces.append(contentsOf: places)
            }
            
            // Search 2: Modified region search
            if let places = try await performModifiedSearch(request: request) {
                allPlaces.append(contentsOf: places)
            }
            
            // Remove duplicates based on coordinates
            let uniquePlaces = Array(Set(allPlaces))
            
            await MainActor.run {
                if uniquePlaces.isEmpty {
                    self.searchState = .notFound
                } else {
                    self.searchState = .found(uniquePlaces)
                }
            }
        } catch {
            print("Search error: \(error)")
            await MainActor.run {
                self.searchState = .notFound
            }
        }
    }

    private func performSearch(request: MKLocalSearch.Request) async throws -> [Place]? {
        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            
            return response.mapItems.compactMap { (item: MKMapItem) -> Place? in
                guard let name = item.name ?? item.placemark.title,
                      item.placemark.coordinate.latitude.isFinite,
                      item.placemark.coordinate.longitude.isFinite else {
                    return nil
                }
                
                let placemark = item.placemark
                let address = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.subLocality,
                    placemark.administrativeArea,
                    placemark.subAdministrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                return Place(
                    name: name,
                    address: address,
                    coordinate: item.placemark.coordinate
                )
            }
        } catch {
            print("Standard search error: \(error)")
            return nil
        }
    }

    private func performModifiedSearch(request: MKLocalSearch.Request) async throws -> [Place]? {
        do {
            // Create a copy of the request with modified parameters
            let modifiedRequest = MKLocalSearch.Request()
            modifiedRequest.naturalLanguageQuery = request.naturalLanguageQuery
            
            // Expand the search region
            let expandedSpan = MKCoordinateSpan(
                latitudeDelta: request.region.span.latitudeDelta * 1.5,
                longitudeDelta: request.region.span.longitudeDelta * 1.5
            )
            modifiedRequest.region = MKCoordinateRegion(
                center: request.region.center,
                span: expandedSpan
            )
            
            let search = MKLocalSearch(request: modifiedRequest)
            let response = try await search.start()
            
            return response.mapItems.compactMap { (item: MKMapItem) -> Place? in
                guard let name = item.name ?? item.placemark.title,
                      item.placemark.coordinate.latitude.isFinite,
                      item.placemark.coordinate.longitude.isFinite else {
                    return nil
                }
                
                let placemark = item.placemark
                let address = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.subLocality,
                    placemark.administrativeArea,
                    placemark.subAdministrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                return Place(
                    name: name,
                    address: address,
                    coordinate: item.placemark.coordinate
                )
            }
        } catch {
            print("Modified search error: \(error)")
            return nil
        }
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) async {
        // Validate coordinates
        guard coordinate.latitude.isFinite && coordinate.longitude.isFinite,
              coordinate.latitude >= -90 && coordinate.latitude <= 90,
              coordinate.longitude >= -180 && coordinate.longitude <= 180 else {
            await MainActor.run {
                self.currentPlace = Place(name: "Validate coordinates error", address: "coordinates are not valid", coordinate: coordinate)
//                self.currentPlace = nil
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
                self.currentPlace = Place(name: "Geocoding error", address: "Geocoding error, please try again", coordinate: coordinate)
//                self.currentPlace = nil
            }
        }
    }
    
    @MainActor
      func selectPlace(_ place: Place) {
          guard place.coordinate.latitude.isFinite && place.coordinate.longitude.isFinite else {
              return
          }
          
          let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
          camera = .region(MKCoordinateRegion(
              center: place.coordinate,
              span: span
          ))
          searchState = .initial
          searchText = ""
          onLocationUpdated(place)
      }
    
    func updateRegion(_ newRegion: MKCoordinateRegion?) {
        guard let newRegion = newRegion,
              newRegion.center.latitude.isFinite && newRegion.center.longitude.isFinite,
              newRegion.span.latitudeDelta.isFinite && newRegion.span.longitudeDelta.isFinite else {
            return
        }
        
        visibleRegion = newRegion
        Task { @MainActor in
            await reverseGeocode(coordinate: newRegion.center)
        }
    }
}


extension Place: Hashable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
