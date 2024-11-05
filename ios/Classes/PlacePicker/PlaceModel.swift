import SwiftUI
import MapKit

// MARK: - Models
struct Place: Identifiable {
    let id = UUID()
    let name: String
    var address: String?
    let coordinate: CLLocationCoordinate2D
    
    var toDictionary: [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "address": address as Any,
            "coordinate": [
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude
            ]
        ]
    }
}
