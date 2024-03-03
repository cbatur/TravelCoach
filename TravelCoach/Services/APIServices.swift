
import Foundation
import Combine

enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

protocol ServiceProvider {
    func openAPIGenerateMCQuestion(qType: QCategory) -> AnyPublisher<ChatGPTResponse, APIError>
    func openAPIGetDailyPlan(qType: QCategory) -> AnyPublisher<ChatGPTResponse, APIError>
    func openAPIGetSampleSentence(qType: QCategory) -> AnyPublisher<ChatGPTResponse, APIError>
    func openAPIGenerateImage(keyword: String) -> AnyPublisher<ChatGPTImageResponse, APIError>
    func searchLocation(keyword: String) -> AnyPublisher<[Location], APIError>
}

class APIService: ServiceProvider {

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
    
    func openAPIGenerateMCQuestion(qType: QCategory) -> AnyPublisher<ChatGPTResponse, APIError> {
        return self.apiCall(Requests.chatAPIGetQuestion(qType: qType).requestOpenAI)
    }
    
    func openAPIGetDailyPlan(qType: QCategory) -> AnyPublisher<ChatGPTResponse, APIError> {
        return self.apiCall(Requests.chatAPIGetDailyPlan(qType: qType).requestOpenAI)
    }
    
    func openAPIGetSampleSentence(qType: QCategory) -> AnyPublisher<ChatGPTResponse, APIError> {
        return self.apiCall(Requests.chatAPIGetSampleSentence(qType: qType).requestOpenAI)
    }
    
    func openAPIGenerateImage(keyword: String) -> AnyPublisher<ChatGPTImageResponse, APIError> {
        return self.apiCall(Requests.chatAPICreateImage(keyword: keyword).requestOpenAIImageCreator)
    }
    
    func searchLocation(keyword: String) -> AnyPublisher<[Location], APIError> {
        return self.apiCall(Requests.searchLocation(keyword: keyword).request)
    }

}

