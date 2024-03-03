
import Foundation

extension String {

    /// format 01/01/200 to 200-01-01
    var formatToApiDate: String {
        if self.contains("/") {
            let items = self.components(separatedBy: "/")
            return items[2] + "-" + items[0] + "-" + items[1]
        } else {
            return self
        }
    }
    
}

extension String {
    func formatForWebSearch() -> String {
        return self.replacingOccurrences(of: " ", with: "+")
    }
}

extension Int {

    /// Modular Day Index
    var getDayName: String {
        
        var dayCode = 0
        
        if self > 7 {
            dayCode = (self - (self/7) * 7) + 1
        } else {
            dayCode = self
        }
        
        switch dayCode {
        case 0:
            return "Sat"
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        default:
            return ""
        }

    }
}
