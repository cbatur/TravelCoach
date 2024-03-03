
import Foundation

struct Location: Codable, Hashable, Identifiable {
    /// sourcery:primaryKey
    let id: Int
    let place_id: String
    let name: String
    let formatted_address: String
    let lat: Double
    let lng: Double
    let icon: String
    //let place_saved: Bool
}
