
import Foundation
import Combine

final class MockServices: ObservableObject {
    
    @Published var aeFlights: [FlightInformation] = []
    @Published var dayItineraries: [DayItinerary] = []
    @Published var airlines: [AirlineBasic] = []
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
    
    func getMockAEFlights() {
        if let fileURL = Bundle.main.url(forResource: "AE_FlightStatus", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                
                let flights = try JSONDecoder().decode([FlightInformation].self, from: data)
                self.aeFlights = flights
                
            } catch {
                print("Error reading or parsing AE_FlightStatus.JSON: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    func searchLocalAirlines(_ keyword: String) {
        if let fileURL = Bundle.main.url(forResource: "AirlineCodes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                
                let airlines = try JSONDecoder().decode([AirlineBasic].self, from: data)
                self.airlines = airlines.filter {
                    $0.airlineCode.contains(keyword) || $0.name.contains(keyword)
                }
                
            } catch {
                print("Error reading or parsing AE_FlightStatus.JSON: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found.")
        }
    }
    
}
