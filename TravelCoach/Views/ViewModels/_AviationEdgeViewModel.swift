import Foundation
import Combine

final class AviationEdgeViewmodel: ObservableObject {

    @Published var loading = false
    @Published var travelData = [TravelSection]()
    @Published var searchPerformed = false

    private var apiService = AviationEdgeAPIService()
    private var cancellable: AnyCancellable?
    
    func getFutureFlights(
        _ futureFlightParams: AEFutureFlightParams,
        flightChecklist: FlightChecklist
    ) {
        let filterAirportCode = flightChecklist.arrivalCity?.codeIataCity ?? ""
        searchPerformed = true
        loading = true
        self.cancellable = self.apiService.futureFlights(futureFlightParams: futureFlightParams)
        .catch {_ in Just([]) }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.loading = false
            self.migrateFutureFlights($0.filter({ flight in
                flight.arrival.iataCode == filterAirportCode.lowercased() &&
                !flight.airline.name.isEmpty
            }), flightChecklist: flightChecklist)
        })
    }
    
    func getCachedFlightsSearch() -> [FlightChecklist] {
        if let savedObjects = UserDefaults.standard.object(forKey: "cachedFlights") as? Data {
            let decoder = JSONDecoder()
            if let loadedObjects = try? decoder.decode([FlightChecklist].self, from: savedObjects) {
                return loadedObjects
            } else { return [] }
        } else { return [] }
    }
    
    func setFlightChecklist(_ f: FlightChecklist) {
        var flightChecklist = getCachedFlightsSearch()
        flightChecklist.append(f)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(flightChecklist) {
            UserDefaults.standard.set(encoded, forKey: "cachedFlights")
        }
    }
    
    func migrateFutureFlights(
        _ flights: [AEFutureFlight],
        flightChecklist: FlightChecklist
    ) {
        if flights.count > 0 {
            setFlightChecklist(flightChecklist)
        }
        
        var travelItems = [TravelItem]()
        for f in flights {
            
            let formattedAirlineName = f.airline.name.capitalizedFirstLetter()
            let subtitle = "\(f.airline.iataCode.uppercased()) \(f.flight.number) (\(f.airline.icaoCode.uppercased()) ➔ \(formattedAirlineName))"
            
            travelItems.append(
                TravelItem(
                    iconName: "airplane.departure",
                    title: "\(f.departure.iataCode) ➔ \(f.arrival.iataCode)",
                    subtitle: subtitle,
                    scheduledTime: f.arrival.scheduledTime
                )
            )
        }
        
        travelData.append(
            TravelSection(
                title: "\(formatDateDisplay(flightChecklist.flightDate ?? Date()))",
                items: travelItems
            )
        )
    }
    
    func resetSearchFlights() {
        self.travelData = []
    }
    
    func deActivateSearch() {
        searchPerformed = false
        self.travelData = []
    }
    
    func clearCachedFlightSearches() {
        UserDefaults.standard.removeObject(forKey: "cachedFlights")
    }
}
