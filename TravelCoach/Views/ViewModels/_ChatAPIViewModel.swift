import Combine
import Foundation
import UIKit

final class ChatAPIViewModel: ObservableObject {
    
    @Published var allEvents: [EventCategory] = []
    @Published var itineraries: [DayItinerary] = []
    @Published var venueInfo: VenueInfo?
    @Published var backgroundLocationImageUrl: String?
    @Published var randomLocationCity: String?
    @Published var imageData: Data = (UIImage(named: "destination_placeholder")?.pngData() ?? Data())
    @Published var imageDataSet: [Data] = []

    private var apiService = APIService()
    private var cancellable: AnyCancellable?
    @Published var loadingMessage: String? = nil
    @Published var loadingIconMessage: String? = nil
    private var apiCount = 0
    private var activityMessage: ActivityIndicatorMessage = .blank
    
    func getChatGPTContent(qType: QCategory, isMock: Bool? = false) {
        switch qType {
            case .getDailyPlan(let city, _), .getAllEvents(let city, _):
                self.fetchRandomLocationPhoto(keyword: city)
            
                if apiCount == 0 {
                    activityMessage = .dayTripInitial(city)
                } else if apiCount == 1 {
                    activityMessage = .dayTripInitial2
                } else {
                    activityMessage = .dayTripInitial3(city)
                }
            
                apiCount = apiCount + 1
            
            if isMock == true {
                executeMockVenueService()
            } else {
                executeService(qType: qType, city: city)
            }
            
        case .getVenueDetails(let location):
            self.executeVenueService(qType: qType, location: location)
        }
    }
    
    func executeMockVenueService() {
        self.fetchRandomLocationPhoto(keyword: "Dublin, Ireland")
        if let fileURL = Bundle.main.url(forResource: "itinerary", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let items = try JSONDecoder().decode([DayItinerary].self, from: data)
                self.itineraries = items
            } catch {
                print("Error reading or parsing progress.JSON: \(error.localizedDescription)")
                self.itineraries = []
            }
        } else {
            print("JSON file not found.")
            self.itineraries = []
        }
    }
    
    func executeService(
        qType: QCategory,
        city: String
    ) {
        self.loadingMessage = self.activityMessage.content
        self.cancellable = self.apiService.openAPIGetDailyPlan(qType: qType)
            .catch {_ in Just(ChatGPTResponse(id: "0", choices: [])) }
            .sink(receiveCompletion: { _ in }, receiveValue: {
                guard let questionSet = $0.choices.first?.message.content else { return }

                if let jsonData = questionSet.data(using: .utf8) {
                    do {
                        switch qType {
                        case .getDailyPlan:
                            let items = try JSONDecoder().decode([DayItinerary].self, from: jsonData)
                            self.itineraries = items
                            //self.fetchRandomLocationPhoto(keyword: city)
                        case .getAllEvents:
                            let items = try JSONDecoder().decode([EventCategory].self, from: jsonData)
                            self.loadingMessage = "api 3"
                            self.allEvents = items
                        default:
                            break
                        }
           
                        self.loadingMessage = nil
                        
                    } catch {
                        self.getChatGPTContent(qType: qType)
                    }
                }
            })
    }
    
    func executeVenueService(
        qType: QCategory,
        location: String
    ) {
        self.loadingMessage = self.activityMessage.content
        self.cancellable = self.apiService.openAPIGetDailyPlan(qType: qType)
            .catch {_ in Just(ChatGPTResponse(id: "0", choices: [])) }
            .sink(receiveCompletion: { _ in }, receiveValue: {
                guard let questionSet = $0.choices.first?.message.content else { return }
                self.fetchRandomLocationPhoto(keyword: location)

                if let jsonData = questionSet.data(using: .utf8) {
                    do {
                        let item = try JSONDecoder().decode(VenueInfo.self, from: jsonData)

                        self.venueInfo = item
                        self.loadingMessage = nil
                    } catch {
                        //self.getDailyitinerary(qType: qType)
                        print("Error deserializing JSON: \(error)")
                    }
                }
            })
    }
    
    // Fetch Photos of the Search City
    func fetchRandomLocationPhoto(keyword: String) {
        self.randomLocationCity = nil
        self.cancellable = self.apiService.openAPIGenerateImage(keyword: keyword)
        .catch {_ in Just(ChatGPTImageResponse(created: 0, data: [])) }
        .sink(receiveCompletion: {
            _ in
        },
              receiveValue: {
            self.randomLocationCity = keyword
            
            guard let cityIcon = $0.data.first?.url else { return }
            self.backgroundLocationImageUrl = cityIcon
            
            if let _ = URL(string: cityIcon) {
                self.downloadImage(from: cityIcon)
            }
        })
    }
    
    func downloadImage(from urlString: String) {
        self.loadingIconMessage = "Grabbing an icon..."
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                return
            }
            self?.loadingIconMessage = nil
            DispatchQueue.main.async {
                if let pngData = image.pngData() {
                    self?.imageData = pngData
                }
            }
        }.resume()
    }
}
