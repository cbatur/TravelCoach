
import Foundation

struct AirlineBasic: Codable, Identifiable, Hashable {
    var id: String { airlineCode }
    let airlineCode: String
    let name: String
}
