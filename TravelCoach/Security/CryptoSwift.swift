
import Foundation
import Combine
import CryptoSwift

final class CryptoSwiftViewModel: ObservableObject {
    
    @Published var key = ""

    // --------- To generate a new CryptoSet ------
    // Paste this func in ChatGPT and command to create a random keyHex and ivHex
    // Print it via this ViewModel and delete it from here
    // --------------------------------------------
    // Create a random keyHex and ivHex
    func shuffleAPIKey() {
        let keyHex = ""
        let ivHex = ""
        let keyToEncrypt = "" // Place real API Key to generate encryptedBase64, and replace in config.

        do {
            let key = Array<UInt8>(hex: keyHex)
            let iv = Array<UInt8>(hex: ivHex)

            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
            let encryptedBytes = try aes.encrypt(Array(keyToEncrypt.utf8))
            let encryptedBase64 = encryptedBytes.toBase64()
            print("[Debug] - Generate Encrypted encryptedBase64 Key: \(encryptedBase64)")
            self.key = encryptedBase64
        } catch {
            print("An error occurred: \(error)")
        }
    }
}

public func decryptAPIKey(_ cryptoKeySet: CryptoKeySet) -> String? {
    let keyHex = cryptoKeySet.package.keyHex
    let ivHex = cryptoKeySet.package.ivHex
    let encryptedBase64 = cryptoKeySet.package.encryptedBase64

    do {
        let key = Array<UInt8>(hex: keyHex)
        let iv = Array<UInt8>(hex: ivHex)

        guard let encryptedBytes = Data(base64Encoded: encryptedBase64)?.bytes else {
            return nil
        }

        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        let decryptedBytes = try aes.decrypt(encryptedBytes)

        if let decryptedString = String(bytes: decryptedBytes, encoding: .utf8) {
            return decryptedString

        } else {
            return nil
        }
    } catch {
        return nil
    }
}

struct CryptoPackage {
    let keyHex: String
    let ivHex: String
    let encryptedBase64: String
}

public enum CryptoKeySet {
    case openAI
    case googlePlaces
    case avionEdge
    
    var package: CryptoPackage {
        switch self {
        case .openAI:
            return CryptoPackage(
                keyHex: Configuration.openAI.keyHex,
                ivHex: Configuration.openAI.ivHex,
                encryptedBase64: Configuration.openAI.encryptedBase64
            )
        case .googlePlaces:
            return CryptoPackage(
                keyHex: Configuration.GooglePlaces.keyHex,
                ivHex: Configuration.GooglePlaces.ivHex,
                encryptedBase64: Configuration.GooglePlaces.encryptedBase64
            )
        case .avionEdge:
            return CryptoPackage(
                keyHex: Configuration.AvionEdge.keyHex,
                ivHex: Configuration.AvionEdge.ivHex,
                encryptedBase64: Configuration.AvionEdge.encryptedBase64
            )
        }
    }
}
