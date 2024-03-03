
import Foundation

struct AllEvents: Decodable, Hashable {
    let categories: [EventCategory]
}

struct EventCategory: Decodable, Hashable {
    let category: String
    let events: [String]
}
