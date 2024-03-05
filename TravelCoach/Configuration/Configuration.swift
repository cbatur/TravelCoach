
import Foundation

enum Configuration {
    static let accessToken = "35433@!D65HW66$$bTT2854SSpw!A"
    static let api = "https://palamana.com/baturca/"
    static let environment = "http://addictivespanish.com/"
    static let isMock: Bool = false

    enum openAI {
        static let apiOpenAI = "https://api.openai.com/v1/"
        static let openAPIModel = "gpt-3.5-turbo"
        static let keyHex = "56a8913384b58750a548f8636d13060170249d393fecfe40c039e19b589d7e37"
        static let ivHex = "0adb5939d04f75262d5006d3c5d80e7f"
        static let encryptedBase64 = "53MRYmA5dFF/zlrptbKdlULfEgbo2oJvI84MW+fbIPngPlw8rQw1Wh0GddStM9ud2PG5iQ1IoifkyeqWUm+e7g=="
    }
    
    enum Links {
        static let agreementsURL = URL(string: "\(environment)agreements/termsagreements.php")!
        static let privacyPolicyURL = URL(string: "\(environment)agreements/privacypolicy.php")!
        static let agreementsTitle = "Terms and Agreements"
        static let privacyTitle = "Privacy Policy"
        static let rateThisAppTitle = "Rate This App"
    }
    
}
