
import Foundation

extension Date {

    /// return yesterday date
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    /// return tomorrow date
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    /// return day from date
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }

    /// return month from date
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }

    /// return year from date
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }

    /// return previous month date
    var previousMonthDate: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    /// return next month date
    var nextMonthDate: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }

    /// return true is it is last day of month
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }

    /// return start date of month
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    /// return end date of month
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }

    /// return start date of last month
    var startOfLastMonth: Date {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }

    /// return end date of last month
    var endOfLastMonth: Date {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 1
        components.day! -= 1
        return Calendar.current.date(from: components)!
    }

    /// return last week date
    var last7Day: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }

    /// return last month date
    var last30Day: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)!
    }

    /// return last 6 month date
    var last6Month: Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)!
    }

    /// return last 3 month date
    var last3Month: Date {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)!
    }

    /// return date by adding numbner of days
    func dateByAdding(days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }

    var dayOfWeek: Int {
        var dayOfWeek = Calendar.current.component(.weekday, from: self) + 1 - Calendar.current.firstWeekday

        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }

        return dayOfWeek
    }

    var dayNameOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    var startOfWeek: Date {
        return Calendar.current.date(byAdding: DateComponents(day: -(self.dayOfWeek + 1)), to: self)!
    }

    var endOfWeek: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 6), to: self.startOfWeek)!
    }

    var startOfQuarter: Date {
        let quarter = (Calendar.current.component(.month, from: self) - 1) / 3 + 1
        return Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: self), month: (quarter - 1) * 3 + 1))!
    }

    var endOfQuarter: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 3, day: -1), to: self.startOfQuarter)!
    }

    var startOfYear: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: self))!
    }

    var endOfYear: Date {
        return Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: self), month: 12, day: 31))!
    }


    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var seconds: Int {
        return Calendar.current.component(.second, from: self)
    }

    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }

    func stringWith(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    public var currentTimeStamp: String {
        return "\(timeIntervalSince1970 * 1000)"
    }
    
    public func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }
    
    public func yearName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}

extension Date {

    static func daysFromToday(_ days: Int) -> Date {
        Date().addingTimeInterval(TimeInterval(60*60*24*days))
    }

}

extension Date {

    var fullDate: String {
        DateFormatter.fullDate.string(from: self)
    }

    var timeOnlyWithPadding: String {
        DateFormatter.timeOnlyWithPadding.string(from: self)
    }
    
    var travelDate: String {
        DateFormatter.travelDate.string(from: self)
    }

}

extension DateFormatter {

    static var travelDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }

    static var fullDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }

    static let timeOnlyWithPadding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

}
