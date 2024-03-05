
import Foundation
import Combine
import CryptoSwift

final class CryptoSwiftViewModel: ObservableObject {
    func shuffleAPIKey() {
        let keyHex = "56a8913384b58750a548f8636d13060170249d393fecfe40c039e19b589d7e37"
        let ivHex = "0adb5939d04f75262d5006d3c5d80e7f"
        let openAPIKey = "sk-tc..." // Place real API Key to generate encryptedBase64, and replace in config.

        do {
            let key = Array<UInt8>(hex: keyHex)
            let iv = Array<UInt8>(hex: ivHex)

            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
            let encryptedBytes = try aes.encrypt(Array(openAPIKey.utf8))
            let encryptedBase64 = encryptedBytes.toBase64() 
            print(encryptedBase64)
        } catch {
            print("An error occurred: \(error)")
        }
    }
}
