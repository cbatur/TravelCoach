
import Foundation

struct AirlineBasic: Codable, Identifiable, Hashable {
    var id: String { airlineCode }
    let airlineCode: String
    let name: String
}

struct FlightChecklist: Decodable, Encodable, Identifiable, Equatable {
    var id = UUID()
    
    let departureCity: AEAirport.AECity?
    let arrivalCity: AEAirport.AECity?
    let flightDate: Date?
}
