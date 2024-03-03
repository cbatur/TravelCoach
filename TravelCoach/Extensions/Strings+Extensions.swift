
import Foundation

extension String {
    func sanitizeOptions() -> String {
        
        var sanitized = self.replacingOccurrences(of: "A. ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "B. ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "C. ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "D. ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "A) ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "B) ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "C) ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "D) ", with: "")
        
        return sanitized
    }
    
    func sanitizeMarks() -> String {
        var sanitized = self.replacingOccurrences(of: ". ", with: "")
        sanitized = sanitized.replacingOccurrences(of: ", ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "? ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "¿ ", with: "")
        sanitized = sanitized.replacingOccurrences(of: "! ", with: "")
        return sanitized
    }
    
    func searchSanitized() -> String {
        var sanitized = self.replacingOccurrences(of: " ", with: "+")
        return sanitized
    }
}
