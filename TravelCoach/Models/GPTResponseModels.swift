
import Foundation

struct DayItinerary: Decodable, Hashable {
    let index: Int
    let title: String
    var date: String
    let activities: [Activity]
}

struct Activity: Decodable, Hashable {
    let index: Int
    let title: String
    let categories: [String]
}

struct VenueInfo: Decodable, Hashable {
    let venueName: String
    let venueDescription: String
    let city: String
    let country: String
    let locationName: String
}
