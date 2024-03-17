
import Foundation

struct FlightInformation: Codable, Hashable {
    let airline: Airline
    let arrival: OneWayFlight
    //let codeshared: String? // Assuming this is a String, adjust based on actual data type
    let departure: OneWayFlight
    let flight: Flight
//    let status: String
//    let type: String



}

struct Airline: Codable, Hashable {
    let iataCode: String
    let icaoCode: String
    let name: String
}

struct OneWayFlight: Codable, Hashable {
    let actualRunway: String?
    let actualTime: String?
    let baggage: String?
    let delay: String?
    let estimatedRunway: String?
    let estimatedTime: String?
    let gate: String?
    let iataCode: String
    let icaoCode: String
    let scheduledTime: String
    let terminal: String?
}

struct Flight: Codable, Hashable {
    let iataNumber: String
    let icaoNumber: String
    let number: String
}
