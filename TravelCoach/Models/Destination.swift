
import Foundation
import SwiftData
import UIKit

@Model
class Destination {
    var id: String = UUID().uuidString
    var name: String
    var details: String
    var googlePlaceId: String?
    var startDate: Date
    var endDate: Date
    var priority: Int
    var icon: Data?
    @Relationship(deleteRule: .cascade) var allEvents = [AllEventsSD]()
    @Relationship(deleteRule: .cascade) var itinerary = [Itinerary]()
    
    init(
        name: String = "",
        details: String = "",
        startDate: Date = .now,
        endDate: Date = .now,
        priority: Int = 2
    ) {
        self.name = name
        self.details = details
        self.startDate = startDate
        self.endDate = endDate
        self.priority = priority
    }
}

@Model
class Itinerary: Hashable {
    let index: Int
    let title: String
    var date: String
    let activities: [EventItem]

    init(
        index: Int,
        title: String,
        date: String,
        activities: [EventItem]
    ) {
        self.index = index
        self.title = title
        self.date = date
        self.activities = activities
    }

    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        return lhs.index == rhs.index && lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(title)
    }
}

@Model
class EventItem: Hashable {
    let index: Int
    let title: String
    let categories: [String]
    
    init(index: Int, title: String, categories: [String]) {
        self.index = index
        self.title = title
        self.categories = categories
    }
    
    static func == (lhs: EventItem, rhs: EventItem) -> Bool {
        return lhs.index == rhs.index
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}

@Model
class AllEventsSD: Hashable {
    let index: Int
    //let title: String
    let categories: [EventCategorySD]

    init(index: Int, categories: [EventCategorySD]) {
        self.index = index
        //self.title = title
        self.categories = categories
    }

    static func == (lhs: AllEventsSD, rhs: AllEventsSD) -> Bool {
        return lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        //hasher.combine(title)
    }
}

@Model
class EventCategorySD: Hashable {
    let index: Int
    let category: String
    let events: [String]
    
    init(index: Int, category: String, events: [String]) {
        self.index = index
        self.category = category
        self.events = events
    }
    
    static func == (lhs: EventCategorySD, rhs: EventCategorySD) -> Bool {
        return lhs.index == rhs.index
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}


//
//@Model
//class AllEventsSD: Hashable, PersistentModel {
//    var id: String = UUID().uuidString
//    let categories: [EventCategorySD]
//    
//    init(categories: [EventCategorySD]) {
//        self.categories = categories
//    }
//
//    static func == (lhs: AllEventsSD, rhs: AllEventsSD) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//@Model
//struct EventCategorySD: Hashable {
//    var index: String = UUID().uuidString
//    let category: String
//    let events: [String]
//    
//    init(category: String, events: [String]) {
//        self.category = category
//        self.events = events
//    }
//    
//    static func == (lhs: EventCategorySD, rhs: EventCategorySD) -> Bool {
//        return lhs.index == rhs.index
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(index)
//    }
//}

