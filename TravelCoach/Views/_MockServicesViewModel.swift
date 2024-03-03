

import Foundation
import Combine

final class MockServices: ObservableObject {
    
    @Published var dayItineraries: [DayItinerary] = []
    @Published var allEvents: AllEvents = AllEvents(categories: [])
    
    func getMockItineraries(_ city_id: Int? = 1) {
        if let fileURL = Bundle.main.url(forResource: "itinerary", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let itineraries = try JSONDecoder().decode([DayItinerary].self, from: data)
                self.dayItineraries = itineraries
            } catch {
                print("Error reading or parsing city.JSON: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    func getMockAllEvents() {
        if let fileURL = Bundle.main.url(forResource: "allEvents", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let events = try JSONDecoder().decode(AllEvents.self, from: data)
                self.allEvents = events
            } catch {
                print("Error reading or parsing city.JSON: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found.")
        }
    }
}
