import SwiftUI
import MapKit

//extension MKCoordinateRegion {
//    func isSignificantlyDifferent(from other: MKCoordinateRegion, threshold: CLLocationDegrees = 0.001) -> Bool {
//        let latDiff = abs(center.latitude - other.center.latitude)
//        let lonDiff = abs(center.longitude - other.center.longitude)
//      
//        
//        return latDiff > threshold || lonDiff > threshold
//    }
//}


extension MKCoordinateRegion {
    func isSignificantlyDifferent(from other: MKCoordinateRegion, threshold: CLLocationDistance = 5) -> Bool {
        let currentLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let otherLocation = CLLocation(latitude: other.center.latitude, longitude: other.center.longitude)
        
        // Check if the distance exceeds the threshold in meters
        return currentLocation.distance(from: otherLocation) > threshold
    }
}



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
