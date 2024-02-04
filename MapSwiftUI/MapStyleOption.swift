import MapKit
import SwiftUI

enum MapStyleOption: String, CaseIterable {
    case standard, hybrid, imagery, realisticImagery

    var mapStyle: MapStyle {
        switch self {
        case .standard:
            return .standard

        case .hybrid:
            return .hybrid

        case .imagery:
            return .imagery

        case .realisticImagery:
            return .standard(elevation: .realistic)
        }
    }

    var icon: String {
        switch self {
        case .standard:
            return "square.2.layers.3d"
        case .hybrid:
            return "road.lanes"
        case .imagery:
            return "photo"
        case .realisticImagery:
            return "view.3d"
        }
    }
}

