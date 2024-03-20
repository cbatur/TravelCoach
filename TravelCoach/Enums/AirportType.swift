
import Foundation

enum AirportType {
    case departure
    case arrival
    
    var message: String {
        switch self {
        case .departure:
            return "Select your airport of departure"
        case .arrival:
            return "Select your arrival airport"
        }
    }
    
    var placeholder: String {
        switch self {
        case .departure:
            return "Departure City"
        case .arrival:
            return "Arrival City"
        }
    }
    
    var icon: String {
        switch self {
        case .departure:
            return "airplane.departure"
        case .arrival:
            return "airplane.arrival"
        }
    }
}

