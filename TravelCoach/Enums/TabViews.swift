
import Foundation

enum TabViews {
    case overview
    case reservations
    case itinerary
    case settings
    
    var title: String {
        switch self {
        case .overview:
            return "Overview"
        case .reservations:
            return "Reservations"
        case .itinerary:
            return "itinerary"
        case .settings:
            return "Settings"
        }
    }
    
}
