import Foundation

struct ChatGPTResponse: Codable {
    let id: String
    let choices: [Choice]
}

struct Choice: Codable {
    let index: Int
    let message: ChatGPTRawResponse
}

struct ChatGPTRawResponse: Codable {
    let role: String
    let content: String
}

struct ChatGPTImageResponse: Codable {
    let created: Int
    let data: [AIImageUrl]
}

struct AIImageUrl: Codable {
    let url: String
}
