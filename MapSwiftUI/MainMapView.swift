import SwiftUI

struct MainMapView: View {
    let sfPlaces = SFPlace.topAttractions

    var body: some View {
        NavigationStack {
            List {
                ForEach(sfPlaces) { place in
                    NavigationLink(value: place) {
                        VStack(alignment: .leading) {
                            Text(place.title)
                                .font(.title)
                                .bold()
                            Text(place.desc)
                        }
                    }
                }
            }
            .navigationTitle("SF Top Attractions")
            .navigationDestination(for: SFPlace.self) { place in
                MapDetailView(place: place)
            }
        }
    }
}

#Preview {
    MainMapView()
}
