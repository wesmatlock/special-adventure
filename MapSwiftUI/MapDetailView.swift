import MapKit
import SwiftUI

struct MapDetailView: View {
    var place: SFPlace
    @State private var camera: MapCameraPosition
    @State private var selectedCategory: String = "atm"
    @State private var markers: [DTMarker] = []

    @State var selectedMapStyle = MapStyleOption.standard

    @State var selectedItemId: UUID?
    @State var selectedMarker: DTMarker?

    @State private var selectedLookAroundScene: MKLookAroundScene?
    @State private var showInfoSheet = false

    init(place: SFPlace) {
        self.place = place
        self._camera = State(
            initialValue: MapCameraPosition.region(
                MKCoordinateRegion(center: place.coordinates,
                                   latitudinalMeters: 500,
                                   longitudinalMeters: 500)))
    }

    var body: some View {
        VStack {
            Map(position: $camera, selection: $selectedItemId) {
                ForEach(markers) { dtMarker in
                    Marker(dtMarker.name,
                           coordinate: dtMarker.coordinates)
                }
            }
            .mapStyle(selectedMapStyle.mapStyle)
            .overlay(alignment: .top) {
                VStack(alignment: .trailing) {
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
                    
                    MultiStateMapStyleButton(selectedState: $selectedMapStyle)
                        .padding(.trailing, 10)
                }
            }
            .onMapCameraChange { context in
                camera = MapCameraPosition.region(context.region)
            }
            .onChange(of: camera) { oldValue, newValue in
                performSearch()
            }
            .onChange(of: selectedCategory) { oldValue, newValue in
                performSearch()
            }
            .onChange(of: selectedItemId, { _, newValue in
                if let firstMarker = markers.first(where: { $0.id == newValue }) {
                    selectedMarker = firstMarker
                    Task {
                        let request = MKLookAroundSceneRequest(coordinate: firstMarker.coordinates)
                        if let scene = try? await request.scene {
                            selectedLookAroundScene = scene
                        }
                        showInfoSheet = true
                    }
                }
            })
            .sheet(item: $selectedMarker) { marker in
                VStack {
                    if let selectedLookAroundScene {
                        LookAroundPreview(initialScene: selectedLookAroundScene)
                    } else if let selectedMarker {
                        Text(selectedMarker.address)
                    }
                }
                .ignoresSafeArea()
                .presentationDetents([.fraction(0.15), .medium])
                .presentationDragIndicator(.visible)
            }

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
                         coordinates: $0.placemark.coordinate, address: addressBuilder(placemark: $0.placemark))
            }
        }
    }

    private func addressBuilder(placemark: MKPlacemark) -> String {
        var address = ""

        if let subThoroughfare = placemark.subThoroughfare {
            address = subThoroughfare + " "
        }
        if let thoroughfare = placemark.thoroughfare {
            address += thoroughfare + " "
        }
        if let postalCode = placemark.postalCode {
            address += postalCode + " "
        }
        if let locality = placemark.locality {
            address += locality + " "
        }
        if let adminArea = placemark.administrativeArea {
            address += adminArea + " "
        }
        if let country = placemark.country {
            address += country + " "
        }

        return address
    }
}

#Preview {
    MapDetailView(place: SFPlace.topAttractions[0])
}
