
import Foundation

extension String {
    
    func convertStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func convertDateToDisplayFormat() -> String {
        guard let date = self.convertStringToDate() else { return "N/A" }
        
        return date.convertDateToString()
    }
}
