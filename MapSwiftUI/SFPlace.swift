import CoreLocation
import Foundation

struct SFPlace: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let coordinates: CLLocationCoordinate2D
    let desc: String

    static func == (lhs: SFPlace, rhs: SFPlace) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

extension SFPlace {
    static var topAttractions: [SFPlace] {
        [
            .init(title: "Alcatraz Island", coordinates: CLLocationCoordinate2D(latitude: 37.827067169207666, longitude: -122.42297807385017), desc: "Alcatraz Island was once the most secure federal prison in the U.S., and held notorious inmates like Al Capone. After being decommissioned in 1963, the prison is now a museum, welcoming millions of curious travelers every year. Catch the ferry on Pier 33 to Alcatraz and explore the island at your own pace as you soak up the views of San Francisco and the bay. You can take a guided tour with a park ranger to learn more about the intriguing anecdotes about the facility’s fascinating history"),
            .init(title: "Golden Gate Bridge", coordinates: CLLocationCoordinate2D(latitude: 37.82008884995976, longitude: -122.47848470083818), desc: "Stretching 4,200 feet and towering as high as a 65-story building, this well-known bridge is the gateway to San Francisco.")
        ]
    }
}
