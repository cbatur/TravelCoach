
import Foundation
import Combine

protocol AEServiceProvider {
    func flightTrack(airlineSearchParams: AirlineSearchParams) -> AnyPublisher<[FlightInformation], APIError>
    func futureFlights(futureFlightParams: AEFutureFlightParams) -> AnyPublisher<[AEFutureFlight], APIError>
}

class AviationEdgeAPIService: AEServiceProvider {

    private func apiCall<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in APIError.serverError }
            .map { $0.data }
            .print()
            .decode(type: T.self, decoder: JSONDecoder())
            .print()
            .mapError { _ in APIError.parsingError }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func flightTrack(airlineSearchParams: AirlineSearchParams) -> AnyPublisher<[FlightInformation], APIError> {
        return self.apiCall(AERequests.FlightTrack(airlineSearchParams: airlineSearchParams).request)
    }
    
    func futureFlights(futureFlightParams: AEFutureFlightParams) -> AnyPublisher<[AEFutureFlight], APIError> {
        return self.apiCall(AERequests.FutureFlights(futureFlightParams: futureFlightParams).request)
    }

}

