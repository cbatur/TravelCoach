
import Foundation

enum QCategory {
    case getDailyPlan(city: String, dateRange: String)
    case getVenueDetails(location: String)
    case getAllEvents(city: String, dateRange: String)
    
    var title: String {
        switch self {
        case .getDailyPlan(let city, let dateRange):
            return "Itinerary for \(city) between \(dateRange)"
        case .getVenueDetails(let location):
            return "Venue Infiormation \(location)"
        case .getAllEvents(let city, let dateRange):
            return "All events for \(city) between \(dateRange)"
        }
    }
    
    var chatDescription: String {
        switch self {
        case .getDailyPlan(let city, let dateRange):
            return "Make a travel plan for \(city) between dates \(dateRange), in a json format using the following format " + dailyPlanExtension
        case .getVenueDetails(let location):
            return "\(location) " + venueInformationExtension
        case .getAllEvents(let city, let dateRange):
            return "Generate a list of events to do in \(city), for dates \(dateRange)" + allEvents
        }
    }
    
    var content: String {
        return "\(chatDescription)"
    }
}

func appendJsonModel(filename: String) -> String {
    guard let fileURL = Bundle.main.url(forResource: "\(filename)", withExtension: "json") else {
        print("Failed to locate the JSON file.")
        return ""
    }
    
    do {
        
        let jsonData = try Data(contentsOf: fileURL)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else { return "" }
    } catch {
        return ""
    }
}

public let allEvents = " group them by category such as art, nature, sports, dining, entertainment, festival, event. Add as many places to visit like parks, amusement centers, historic places as possible. Return the response in json format with a String key as 'category' with the value category and a key named events as a string array as the events. List it for visitors to make a travel plan, do not list a category If it has no values.  Use the format { category: '', events: [] }"

public let dailyPlanExtension = "return in an array of json object of title with key named 'title', and a key named 'date' with the date of the particular day with format 'yyyy-MM-dd', and a key named index for the order as Integer, and a key named 'activities' as [Activity], where Activity has a key named title for title and a key named index for the order as Integer and categories as category of activity as a string array such as, restaurant, sports, checkin, checkout, drive, train, bus, art, nature, museum, nightlife etc"

public let venueInformationExtension = "return as a json object of keys venueName and venueDescription as string, also city, country as Strings and locationName in a format to be searched for geolocation."
