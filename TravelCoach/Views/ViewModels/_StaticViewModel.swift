
import Foundation
import Combine

final class StaticViewModel: ObservableObject {
    
    @Published var queryAirlines = ""
    @Published private(set) var airlines: [AirlineBasic] = []
    
    init() {
        $queryAirlines
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (queryString) -> AnyPublisher<[AirlineBasic], Never> in
                if queryString.count < 3 {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.fetchAutocomplete(queryString)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .assign(to: &$airlines)
    }
    
    private func fetchAutocomplete(_ query: String) -> AnyPublisher<[AirlineBasic], Error> {
        // Specify the local JSON file name, assuming it's in the main bundle
        let localFileName = "AirlineCodes" // Replace 'yourLocalFileName' with your actual file name
        
        // Create a Combine publisher that attempts to load the local JSON file
        return Future<[AirlineBasic], Error> { promise in
            // Use the main bundle to locate the file (make sure it's included in your target)
            guard let path = Bundle.main.path(forResource: localFileName, ofType: "json") else {
                promise(.failure(URLError(.fileDoesNotExist)))
                return
            }
            
            do {
                // Load the file contents
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                // Decode the JSON into the expected array of AirlineBasic objects
                let airlines = try JSONDecoder().decode([AirlineBasic].self, from: data)
                // Complete with the decoded object
                
                self.airlines = Array(airlines.filter {
                    $0.airlineCode.contains(self.queryAirlines) || $0.name.contains(self.queryAirlines)
                }.prefix(20))
                
                promise(.success(airlines))
            } catch {
                // If there's an error reading or decoding the file, complete with failure
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
//    private func fetchAutocomplete(_ query: String) -> AnyPublisher<[AirlineBasic], Error> {
//        let urlString = "https://maps.domain.com/maps/api/place/autocomplete/json?inpu"
//        
//        guard let url = URL(string: urlString) else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//        
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: [AirlineBasic].self, decoder: JSONDecoder())
//            .map { response in
//                response.map { $0 }
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
    func selectSuggestion(_ suggestion: String) {
        self.queryAirlines = suggestion
        self.airlines = []
    }
    
//    func searchLocalAirlines(_ keyword: String) -> AnyPublisher<[AirlineBasic], Error> {
//        if let fileURL = Bundle.main.url(forResource: "AirlineCodes", withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: fileURL)
//                    .map(\.data)
//                    .decode(type: [AirlineBasic].self, decoder: JSONDecoder())
//                    .map { response in
//                        response.map { $0 }
//                    }
//                    .receive(on: DispatchQueue.main)
//                    .eraseToAnyPublisher()
//                
////                let airlines = try JSONDecoder().decode([AirlineBasic].self, from: data)
////                self.airlines = Array(airlines.filter {
////                    $0.airlineCode.contains(queryAirlines) || $0.name.contains(queryAirlines)
////                }.prefix(20))
//                
//            } catch {
//                print("Error reading or parsing AE_FlightStatus.JSON: \(error.localizedDescription)")
//            }
//        } else {
//            print("JSON file not found.")
//        }
//    }
    
    func resetSearch() {
        self.queryAirlines = ""
        self.airlines = []
    }
    
}
