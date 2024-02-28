import MapKit
import Observation
import SwiftUI

@Observable
final class TPLocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = TPLocationManager()

    let locationManager = CLLocationManager()

    var region = MKCoordinateRegion()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {

        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location access is restricted!")
        case .denied:
            print("Location access was denied!")
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
