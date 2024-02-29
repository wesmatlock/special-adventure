import MapKit
import SwiftUI

struct SearchNearBy: View {

    @State private var locationManager = TPLocationManager.shared
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)

    // Search
    @State private var searchText = ""
    @State private var markers = [MKMapItem]()
    @State private var visibleRegion: MKCoordinateRegion?

    // selection
    @State private var selectedMapItem: MKMapItem?

    // directions
    @State private var route: MKRoute?

    var body: some View {
        NavigationStack {

            ZStack(alignment: .top) {
                Map(position: $position, selection: $selectedMapItem) {
                    ForEach(markers, id: \.self) { marker in
                        Marker(item: marker)
                    }

                    UserAnnotation()

                    if let route {
                        MapPolyline(route)
                            .stroke(.orange, lineWidth: 6)
                    }
                }
                .onChange(of: locationManager.region) { oldValue, newValue in
                    withAnimation {
                        position = .region(locationManager.region)
                    }
                }
                .onMapCameraChange { context in
                    visibleRegion = context.region
                }

                VStack {
                    TextField("Search Map", text: $searchText)
                        .onSubmit {
                            fetchSearchResults()
                        }
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .opacity(0.7)

                    if let selectedMapItem {
                        Button("Get Directions?") {
                            getDirection(selectedMapItem: selectedMapItem)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Search Nearby POI")

        }
    }

    private func fetchSearchResults() {
        Task {
            markers = await search(for: searchText, in: visibleRegion ?? locationManager.region)
        }
    }

    private func search(for term: String, in region: MKCoordinateRegion?) async -> [MKMapItem] {
        guard term.count >= 3 else { return [] }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = .pointOfInterest

        guard let region = region else { return [] }
        request.region = region

        let search = MKLocalSearch(request: request)
        do {
            let result = try await search.start()
            return result.mapItems
        } catch {
            return []
        }
    }

    private func getDirection(selectedMapItem: MKMapItem) {
        let origin = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.region.center))

        let request = MKDirections.Request()
        request.source = origin
        request.destination = selectedMapItem
        request.requestsAlternateRoutes = false

        Task {
            let directions = MKDirections(request: request)
            let results = try await directions.calculate()
            let routes = results.routes
            if let firstRoute = routes.first {
                route = firstRoute
            }
        }
    }
}
#Preview {
    SearchNearBy()
}
