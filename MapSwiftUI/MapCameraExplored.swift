import MapKit
import SwiftUI

struct MapCameraExplored: View {

    @State private var mapCameraPosition = MapCameraPosition.camera(MapCamera(
        centerCoordinate: SFPlace.topAttractions[0].coordinates,
        distance: 1000
    ))

    @State private var pitchValue: Double = 0
    @State private var headingValue: Double = 0

    var body: some View {
        Map(position: $mapCameraPosition)
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Stepper("Pitch", value: $pitchValue, in: 0...75, step: 15)
                    Stepper("Heading", value: $headingValue, in: 0...500, step: 15)

                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .onChange(of: pitchValue) { _, newValue in
                withAnimation {
                    mapCameraPosition = MapCameraPosition.camera(MapCamera(
                        centerCoordinate: SFPlace.topAttractions[0].coordinates,
                        distance: 1000,
                        heading: headingValue,
                        pitch: newValue
                    ))
                }
            }
            .onChange(of: headingValue) { _, newValue in
                withAnimation {
                    mapCameraPosition = MapCameraPosition.camera(MapCamera(
                        centerCoordinate: SFPlace.topAttractions[0].coordinates,
                        distance: 1000,
                        heading: newValue,
                        pitch: pitchValue
                    ))
                }
            }
    }
}

#Preview {
    MapCameraExplored()
}
