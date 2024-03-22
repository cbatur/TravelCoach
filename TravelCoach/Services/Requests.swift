
import Foundation

enum Requests {
    case chatAPIGetQuestion(qType: QCategory)
    case chatAPIGetDailyPlan(qType: QCategory)
    case chatAPIGetSampleSentence(qType: QCategory)
    case chatAPICreateImage(keyword: String)
    case searchLocation(keyword: String)

    var body: [String: Any] {
        switch self {
        case .chatAPIGetQuestion(let qType):
            return ["category": qType]
        case .chatAPIGetDailyPlan(let qType):
            return ["category": qType]
        case .chatAPIGetSampleSentence(let qType):
            return ["category": qType]
        case .chatAPICreateImage(let keyword):
            return ["keyword": keyword]
        case .searchLocation(let keyword):
            return ["keyword": keyword]
        }
    }
    
    var path: String {
        switch self {
        case .chatAPIGetQuestion( _), 
                .chatAPIGetDailyPlan( _),
                .chatAPIGetSampleSentence( _):
            return "chat/completions"
        case .chatAPICreateImage( _):
            return "images/generations"
        case .searchLocation( _):
            return "places/search.php"
        }
    }
    
    var chatContent: String {
        switch self {
        case .chatAPIGetQuestion(let qType), 
                .chatAPIGetSampleSentence(let qType),
                .chatAPIGetDailyPlan(let qType):
            return qType.content
        case .chatAPICreateImage( _), .searchLocation( _):
            return ""
        }
    }
    
    var request: URLRequest {
        
        let path = "\(Configuration.api)\(self.path)"
        guard let url = URL(string: path) else { preconditionFailure("Bad URL") }

        var body = self.body
        body["accessToken"] = Configuration.accessToken

        guard let postData = try? JSONSerialization.data(withJSONObject: body) else {
            fatalError("Invalid Body")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request.prettyDescription)
        return request
    }
    
    var requestOpenAI: URLRequest {
        
        let path = "\(Configuration.openAI.apiOpenAI)\(self.path)"
        guard let url = URL(string: path) else { preconditionFailure("Bad URL") }
        
        guard let openAPIKey = decryptAPIKey(.openAI) else { preconditionFailure("Bad API Key") }
        
        let jsonString = """
        {
            "model": "\(Configuration.openAI.openAPIModel)",
            "messages": [
                {
                    "role": "user",
                    "content": "\(self.chatContent)"
                }
            ]
        }
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonString.data(using: .utf8)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAPIKey)", forHTTPHeaderField: "Authorization")
        
        print(request.prettyDescription)
        return request
    }
    
    var requestOpenAIImageCreator: URLRequest {
        
        let path = "\(Configuration.openAI.apiOpenAI)\(self.path)"
        guard let url = URL(string: path) else { preconditionFailure("Bad URL") }
        
        let title = "\(self.body["keyword"] ?? "")"
        
        let jsonString = """
        {
            "prompt": "\(title)",
            "n": 1,
            "size": "512x512"
          }
        """

        guard let openAPIKey = decryptAPIKey(.openAI) else { preconditionFailure("Bad API Key") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonString.data(using: .utf8)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAPIKey)", forHTTPHeaderField: "Authorization")
        
        print(request.prettyDescription)
        return request
    }
}

extension URLRequest {
    var prettyDescription: String {
        var output = "----- URLRequest Start -----\n"
        
        if let httpMethod = httpMethod {
            output += "HTTP Method: \(httpMethod)\n"
        }
        
        if let url = url {
            output += "URL: \(url.absoluteString)\n"
        }
        
        if let allHTTPHeaderFields = allHTTPHeaderFields {
            output += "Headers:\n"
            for (key, value) in allHTTPHeaderFields {
                output += "- \(key): \(value)\n"
            }
        }
        
        if let httpBody = httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            output += "Body:\n\(bodyString)\n"
        }
        
        output += "----- URLRequest End -----\n"
        return output
    }
}
