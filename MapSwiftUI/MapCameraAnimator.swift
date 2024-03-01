import SwiftUI
import MapKit

struct MapCameraAnimator: View {
    @State var animate: Bool = false

    let alcatraz = SFPlace.topAttractions[0].coordinates
    let goldenGate = SFPlace.topAttractions[1].coordinates

    @State private var mapCameraPosition = MapCameraPosition.camera(MapCamera(
        centerCoordinate: SFPlace.topAttractions[0].coordinates, distance: 5000))

    var body: some View {
        VStack {
            Map(position: $mapCameraPosition)
                .mapStyle(.standard(elevation: .realistic))
                .safeAreaInset(edge: .bottom) {
                    Button("Animate") {
                        animate.toggle()
                    }
                }
                .mapCameraKeyframeAnimator(trigger: animate) { _ in

                    KeyframeTrack(\.pitch) {
                        LinearKeyframe(0, duration: 1.0)
                        LinearKeyframe(75, duration: 1.0)
                    }

                    KeyframeTrack(\.heading) {
                        LinearKeyframe(0, duration: 1.0)
                        LinearKeyframe(-70, duration: 1.0)
                    }
                    KeyframeTrack(\.centerCoordinate) {
                        LinearKeyframe(alcatraz, duration: 1.0)
                        LinearKeyframe(alcatraz, duration: 1.0)
                        LinearKeyframe(goldenGate, duration: 10)
                    }
                }
        }
    }
}
#Preview {
    MapCameraAnimator()
}
