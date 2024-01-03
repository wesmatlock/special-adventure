import MapKit
import SwiftUI

struct MapDetailView: View {
    var place: SFPlace
    @State private var camera: MapCameraPosition

    init(place: SFPlace) {
        self.place = place
        self._camera = State(initialValue: MapCameraPosition.region(MKCoordinateRegion(center: place.coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)))
    }

    var body: some View {
        Map(position: $camera)
            .navigationTitle(place.title)
    }
}

#Preview {
    MapDetailView(place: SFPlace.topAttractions[0])
}
