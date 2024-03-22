
import Foundation

extension AERequests {
    struct Autocomplete {
        var city: String
        
        var request: URLRequest {
            var components = URLComponents(string: "https://aviation-edge.com/v2/public/autocomplete")
            
            guard let apiKey = decryptAPIKey(.avionEdge) else { preconditionFailure("Bad API Key") }
            
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "city", value: city)
            ]
            
            components?.queryItems = queryItems
            
            guard let url = components?.url else { preconditionFailure("Bad URL") }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "accept")

            return request
        }
    }
}
