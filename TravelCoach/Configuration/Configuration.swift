
import Foundation

enum Configuration {
    static let accessToken = "35433@!D65HW66$$bTT2854SSpw!A"
    static let api = "https://palamana.com/baturca/"
    static let environment = "http://addictivespanish.com/"
    static let isMock: Bool = false

    enum openAI {
        static let apiOpenAI = "https://api.openai.com/v1/"
        static let openAPIKey = "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"
        static let openAPIModel = "gpt-3.5-turbo"
    }
    
    enum Links {
        static let agreementsURL = URL(string: "\(environment)agreements/termsagreements.php")!
        static let privacyPolicyURL = URL(string: "\(environment)agreements/privacypolicy.php")!
        static let agreementsTitle = "Terms and Agreements"
        static let privacyTitle = "Privacy Policy"
        static let rateThisAppTitle = "Rate This App"
    }
    
}
