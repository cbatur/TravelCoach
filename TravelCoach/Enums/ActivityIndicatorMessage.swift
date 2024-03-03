
import Foundation

enum ActivityIndicatorMessage {
    case blank
    case dayTripInitial(String)
    case dayTripInitial2
    case dayTripInitial3(String)
    
    var content: String {
        switch self {
        case .blank:
            return ""
        case .dayTripInitial(let city):
            return "SIT TIGHT \nWe're building the perfect itinerary for \(city)"
        case .dayTripInitial2:
            return "This is taking a while because we're looking up everything. \n\nYou're in good hands."
        case .dayTripInitial3(let city):
            return "There are lots of exciting places to do in \(city) \n\nWe're brushing up the details."
        }
    }
}
