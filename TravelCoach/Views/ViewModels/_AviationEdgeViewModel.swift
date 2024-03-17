import Foundation
import Combine

final class AviationEdgeViewmodel: ObservableObject {

    @Published var spinner = false
    @Published var travelData = [TravelSection]()
    
    private var apiService = AviationEdgeAPIService()
    private var cancellable: AnyCancellable?
    
    func getFlights(_ isMock: Bool = false, airlineSearchParams: AirlineSearchParams) {
        if isMock {
            getMockAEFlights()
        } else {
            getFlightsService(airlineSearchParams)
        }
    }

    func getFlightsService(_ airlineSearchParams: AirlineSearchParams) {
        self.cancellable = self.apiService.flightTrack(airlineSearchParams: airlineSearchParams)
        .catch {_ in Just([]) }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.migrateFlights($0)
        })
    }
    
    func getFutureFlights(_ futureFlightParams: AEFutureFlightParams, filterAirportCode: String) {
        self.cancellable = self.apiService.futureFlights(futureFlightParams: futureFlightParams)
        .catch {_ in Just([]) }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            print("[Debug] f- \($0)")
            self.migrateFutureFlights($0.filter({ flight in
                flight.arrival.iataCode == filterAirportCode.lowercased() &&
                !flight.airline.name.isEmpty
            }))
        })
    }
    
    func getMockAEFlights() {
        if let fileURL = Bundle.main.url(forResource: "AE_FlightStatus", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                
                let flights = try JSONDecoder().decode([FlightInformation].self, from: data)
                self.migrateFlights(flights)
            } catch {
                print("Error reading or parsing AE_FlightStatus.JSON: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    func migrateFutureFlights(_ flights: [AEFutureFlight]) {
        var travelItems = [TravelItem]()
        for f in flights {
            
            let formattedAirlineName = f.airline.name.capitalizedFirstLetter()
            let subtitle = "\(f.airline.iataCode.uppercased()) \(f.flight.number) (\(f.airline.icaoCode.uppercased()) - \(formattedAirlineName))"
            
            travelItems.append(
                TravelItem(
                    iconName: "airplane.departure",
                    title: "\(f.departure.iataCode) - \(f.arrival.iataCode)",
                    subtitle: subtitle,
                    scheduledTime: f.arrival.scheduledTime
                )
            )
        }
        
        travelData.append(
            TravelSection(
                title: "WED, JUN 2024",
                items: travelItems
            )
        )
    }
    
    func migrateFlights(_ flights: [FlightInformation]) {
        var travelItems = [TravelItem]()
        for f in flights {
            travelItems.append(
                TravelItem(
                    iconName: "airplane.departure",
                    title: "\(f.departure.iataCode) - \(f.arrival.iataCode)",
                    subtitle: "\(f.airline.iataCode) \(f.flight.number) (\(f.airline.icaoCode) - \(f.airline.name)",
                    scheduledTime: f.arrival.scheduledTime
                )
            )
        }
        
        travelData.append(
            TravelSection(
                title: "WED, JUN 2024",
                items: travelItems
            )
        )
    }
    
    func resetSearchFlights() {
        self.travelData = []
    }
}
