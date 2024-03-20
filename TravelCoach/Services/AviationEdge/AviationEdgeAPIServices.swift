
import Foundation
import Combine

struct AeError: Codable, Error {
    let error: String
    let success: Bool
}

protocol AEServiceProvider {
    func flightTrack(airlineSearchParams: AirlineSearchParams) -> AnyPublisher<[FlightInformation], AeError>
    func futureFlights(futureFlightParams: AEFutureFlightParams) -> AnyPublisher<[AEFutureFlight], AeError>
}

class AviationEdgeAPIService: AEServiceProvider {

    private func apiCall<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, AeError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in AeError(error: "Server Error", success: false) }
            .map { $0.data }
            .print()
            .decode(type: T.self, decoder: JSONDecoder())
            .print()
            .mapError { _ in AeError(error: "Parsing Error", success: false) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func flightTrack(airlineSearchParams: AirlineSearchParams) -> AnyPublisher<[FlightInformation], AeError> {
        return self.apiCall(AERequests.FlightTrack(airlineSearchParams: airlineSearchParams).request)
    }
    
    func futureFlights(futureFlightParams: AEFutureFlightParams) -> AnyPublisher<[AEFutureFlight], AeError> {
        return self.apiCall(AERequests.FutureFlights(futureFlightParams: futureFlightParams).request)
    }

}

