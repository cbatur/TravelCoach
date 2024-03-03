
import Foundation
import SwiftUI

enum TripGroup {
    case activeTrips
    case pastTrips
    case upcomingTrips
    
    var title: String {
        switch self {
        case .activeTrips:
            return "ACTIVE TRIPS"
        case .upcomingTrips:
            return "UPCOMING TRIPS"
        case .pastTrips:
            return "PAST TRIPS"
        }
    }
    
    var foreColor: Color {
        switch self {
        case .activeTrips:
            return Color.wbPinkMedium
        case .upcomingTrips:
            return Color.black
        case .pastTrips:
            return Color.gray
        }
    }
    
    var headerColor: Color {
        switch self {
        case .activeTrips:
            return Color.wbPinkDarkAlt
        case .upcomingTrips:
            return Color.black
        case .pastTrips:
            return Color.gray.opacity(0.7)
        }
    }
}
