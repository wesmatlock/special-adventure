import MapKit
import SwiftUI

struct MapExampleHome: View {
    let sfPlaces = SFPlace.topAttractions
    @State private var showMapView = false

    var body: some View {
        NavigationStack {
            Group {
                if showMapView {
                    mapView
                } else {
                    listView
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showMapView.toggle()
                    } label: {
                        Image(systemName: showMapView ? "list.bullet.circle" : "map.circle")
                    }
                    .font(.title)
                }
            }
        }
    }

    private var listView: some View {
        List {
            ForEach(sfPlaces) { place in
                NavigationLink(value: place) {
                    VStack(alignment: .leading) {
                        Text(place.title)
                            .font(.title)
                            .bold()

                        Text(place.desc)
                        let position = Binding.constant(
                            MapCameraPosition.region(
                                MKCoordinateRegion(
                                    center: place.coordinates,
                                    latitudinalMeters: 500,
                                    longitudinalMeters: 500
                                )
                            )
                        )
                        Map(position: position) {
                            Marker(place.title, systemImage: place.icon, coordinate: place.coordinates)
                                .tint(place.color)
                        }
                        .frame(height: 200)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                }
            }
        }
    }

    private var mapView: some View {
        Map() {
            ForEach(sfPlaces) { place in
                Marker(place.title, systemImage: place.icon, coordinate: place.coordinates)
                    .tint(place.color)
            }
        }
    }
}

#Preview {
    MapExampleHome()
}
