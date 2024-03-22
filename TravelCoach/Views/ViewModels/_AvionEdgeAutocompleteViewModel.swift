
import Foundation
import Combine

class AvionEdgeAutocompleteViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var suggestions: [AEAirport.AECity] = []
    private var cancellables = Set<AnyCancellable>()
        
    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (queryString) -> AnyPublisher<[AEAirport.AECity], Never> in
                if queryString.count < 3 {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.fetchAutocomplete(queryString)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .assign(to: &$suggestions)
    }
    
    private func fetchAutocomplete(_ query: String) -> AnyPublisher<[AEAirport.AECity], Error> {
        
        guard let apiKey = decryptAPIKey(.avionEdge) else { preconditionFailure("Bad API Key") }
        
        let urlString = "https://aviation-edge.com/v2/public/autocomplete?city=\(query)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AEAirport.self, decoder: JSONDecoder())
            .map { response in
                response.airportsByCities
                    .filter({
                        !$0.codeIcaoAirport.isEmpty
                    })
                    .map { $0 }
            }
            .print()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func selectSuggestion(_ suggestion: String) {
        self.query = suggestion
        self.suggestions = []
    }
    
    func resetSearch() {
        self.query = ""
        self.suggestions = []
    }

}

struct AEAirport: Codable {
    let airportsByCities: [AECity]
    
    struct AECity: Codable, Hashable {
        let gmt: String?
        let codeIataAirport, codeIataCity, codeIcaoAirport, codeIso2Country: String
        let latitudeAirport, longitudeAirport: Double
        let nameAirport, nameCountry, phone, timezone: String

        enum CodingKeys: String, CodingKey {
            case gmt
            case codeIataAirport = "codeIataAirport"
            case codeIataCity = "codeIataCity"
            case codeIcaoAirport = "codeIcaoAirport"
            case codeIso2Country = "codeIso2Country"
            case latitudeAirport = "latitudeAirport"
            case longitudeAirport = "longitudeAirport"
            case nameAirport = "nameAirport"
            case nameCountry = "nameCountry"
            case phone = "phone"
            case timezone = "timezone"
        }
    }
}
