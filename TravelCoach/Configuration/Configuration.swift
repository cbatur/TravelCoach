
import Foundation

enum Configuration {
    static let accessToken = "35433@!D65HW66$$bTT2854SSpw!A"
    static let api = "https://palamana.com/baturca/"
    static let apiOpenAI = "https://api.openai.com/v1/"
    static let openAPIKey = "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"
    static let environment = "http://addictivespanish.com/"
    static let isMock: Bool = false

    enum Links {
        static let agreementsURL = URL(string: "\(environment)agreements/termsagreements.php")!
        static let privacyPolicyURL = URL(string: "\(environment)agreements/privacypolicy.php")!
        static let agreementsTitle = "Terms and Agreements"
        static let privacyTitle = "Privacy Policy"
        static let rateThisAppTitle = "Rate This App"
    }
    
}
