
import Foundation

enum Icon: String, CaseIterable {
    case restaurant = "restaurant"
    case sports = "sports"
    case checkin = "checkin"
    case checkout = "checkout"
    case drive = "drive"
    case train = "train"
    case bus = "bus"
    case art = "art"
    case nature = "nature"
    case museum = "museum"
    case nightlife = "nightlife"
    
    var system: String {
        switch self {
        case .restaurant:
            return "fork.knife.circle"
        case .sports:
            return "figure.soccer"
        case .checkin:
            return "pip.enter"
        case .checkout:
            return "pip.exit"
        case .drive:
            return "externaldrive.badge.checkmark"
        case .train:
            return "train.side.rear.car"
        case .bus:
            return "bus.fill"
        case .art:
            return "theatermask.and.paintbrush"
        case .nature:
            return "leaf"
        case .museum:
            return "shekelsign"
        case .nightlife:
            return "wineglass"
        }
    }
}
