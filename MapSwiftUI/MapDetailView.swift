import MapKit
import SwiftUI

struct MapDetailView: View {
    var place: SFPlace
    @State private var camera: MapCameraPosition
    @State private var address: String = ""

    init(place: SFPlace) {
        self.place = place
        self._camera = State(
            initialValue: MapCameraPosition.region(
                MKCoordinateRegion(center: place.coordinates,
                                   latitudinalMeters: 500,
                                   longitudinalMeters: 500)))
    }

    var body: some View {
        Map(position: $camera)
            .overlay {
                Image(systemName: "pin.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.orange.gradient)
            }
            .mapStyle(.standard(pointsOfInterest: .including([MKPointOfInterestCategory.parking, .atm, .bank, .bakery])))
            .onMapCameraChange { context in
                camera = MapCameraPosition.region(context.region)
            }
            .navigationTitle(place.title)
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Text(address)
//                    if let currentRegion = camera.region {
//                        Text("\(currentRegion.center.latitude)")
//                        Text("\(currentRegion.center.longitude)")
//                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial)
            }
            .onChange(of: camera) { oldValue, newValue in
                Task {
                    if let location = await lookUpCurrentLocation() {
                        address = ""
                        address += location.name ?? ""
                        address += " "
                        address += location.locality ?? ""
                    }
                }
            }
    }

    private func lookUpCurrentLocation() async -> CLPlacemark? {
        if let currentRegion = camera.region {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: currentRegion.center.latitude, longitude: currentRegion.center.longitude)
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            return placemarks?.first
        }

        return nil
    }
}

#Preview {
    MapDetailView(place: SFPlace.topAttractions[1])
}
