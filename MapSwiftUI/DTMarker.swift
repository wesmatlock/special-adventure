import CoreLocation
import Foundation

struct DTMarker: Identifiable {
    let id = UUID()
    var name: String
    var coordinates: CLLocationCoordinate2D
}
