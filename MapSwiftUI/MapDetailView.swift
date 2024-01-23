import MapKit
import SwiftUI

struct MapDetailView: View {
    var place: SFPlace
    @State private var camera: MapCameraPosition
    @State private var address: String = ""

    @State var selectedCategory: String = "atm"
    @State private var markers: [DTMarker] = []

    init(place: SFPlace) {
        self.place = place
        self._camera = State(
            initialValue: MapCameraPosition.region(
                MKCoordinateRegion(center: place.coordinates,
                                   latitudinalMeters: 500,
                                   longitudinalMeters: 500)))
    }

    var body: some View {
        Map(position: $camera) {
            ForEach(markers) { dtMarker in
                Marker(dtMarker.name,
                       coordinate: dtMarker.coordinates)
            }
        }
        .overlay(alignment: .top) {
            HStack {
                Picker(selection: $selectedCategory) {
                    Text("Pizza")
                        .tag("pizza")
                    Text("ATM")
                        .tag("atm")
                    Text("Parks")
                        .tag("park")
                } label: {
                    Text("")
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }
            .padding()
        }
        .mapStyle(.standard(elevation: .realistic))
        .onMapCameraChange { context in
            camera = MapCameraPosition.region(context.region)
        }
        .navigationTitle(place.title)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Text(address)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thinMaterial)
        }
        .onChange(of: camera) { oldValue, newValue in
            performSearch()
//            Task {
//                if let location = await lookUpCurrentLocation() {
//                    address = ""
//                    address += location.name ?? ""
//                    address += " "
//                    address += location.locality ?? ""
//                }
//            }
        }
        .onChange(of: selectedCategory) { oldValue, newValue in
            performSearch()
        }
        .navigationTitle(place.title)
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

    private func performSearch() {
        guard let region = camera.region else { return }
        let request = MKLocalSearch.Request()

        request.naturalLanguageQuery = selectedCategory
        request.region = region

        let search = MKLocalSearch(request: request)

        Task {
            guard let results = try? await search.start() else { return }
            markers = results.mapItems.map {
                DTMarker(name: $0.name ?? "",
                         coordinates: $0.placemark.coordinate)
            }
        }
    }
}

#Preview {
    MapDetailView(place: SFPlace.topAttractions[0])
}
