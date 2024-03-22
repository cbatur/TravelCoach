
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
    
    enum AmadeusFlight {
        // Developer Keys
        static let apiKey = "ATxQY0npvb1RzezkdcFsLwADX2WCdH37"
        static let apiSecret = "wNDS5wMQp6ldux6D"
    }
    
    enum AvionEdge {
        static let apiKey = "ba7baa-a8f425"
    }
    
    enum GooglePlaces {
        static let keyHex = "0f018542ac21547c31bbd51f2626962e"
        static let ivHex = "6fb32dd1797ba80a702288554ec27bef"
        static let encryptedBase64 = "essey31h0rzWHbrCBVRCpf86clyd2m2DsVUFf7DGPp6erIRIB09t/4Mm7C/YpgEY"
    }
    
    enum Links {
        static let agreementsURL = URL(string: "\(environment)agreements/termsagreements.php")!
        static let privacyPolicyURL = URL(string: "\(environment)agreements/privacypolicy.php")!
        static let agreementsTitle = "Terms and Agreements"
        static let privacyTitle = "Privacy Policy"
        static let rateThisAppTitle = "Rate This App"
    }
}
