
import Foundation

struct AirlineSearchParams {
    let airlineIata: String?
    let flightNum: String?
}

extension AERequests {
    struct FlightTrack {
        var airlineSearchParams: AirlineSearchParams
        var apiKey: String = "ba7baa-a8f425"
        
        var request: URLRequest {
            var components = URLComponents(string: "https://aviation-edge.com/v2/public/flights")
            
            var queryItems: [URLQueryItem] = [URLQueryItem(name: "key", value: apiKey)]
            
            if let airlineIata = self.airlineSearchParams.airlineIata, !airlineIata.isEmpty {
                queryItems.append(URLQueryItem(name: "airlineIata", value: airlineIata))
            }
            
            if let flightNum = self.airlineSearchParams.flightNum, !flightNum.isEmpty {
                queryItems.append(URLQueryItem(name: "flightNum", value: flightNum))
            }
            
            components?.queryItems = queryItems
            
            guard let url = components?.url else { preconditionFailure("Bad URL") }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "accept")

            return request
        }
    }
}
