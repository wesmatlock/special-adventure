import MapKit
import SwiftUI

struct SearchNearBy: View {
    @State private var locationManager = TPLocationManager.shared
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                UserAnnotation()
            }
            .navigationTitle("Search Nearby POI")
        }
    }
}

#Preview {
    SearchNearBy()
}
