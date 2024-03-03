
import Foundation

class CalendarMethods {
    func createCalendarItems(month: Int, year: Int) -> [CalendarItem] {
                
        var items = [CalendarItem]()
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        let dateFormater = DateFormatter()
        dateFormater.setLocalizedDateFormatFromTemplate("yyyy MM dd, EEE")
        var arrDates: [(weekday:Int, date:String)] = []

        for day in 1...numDays {
            let calendar = Calendar(identifier: .gregorian)
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            
            if let date = calendar.date(from: dateComponents) {
                let components = calendar.dateComponents([.weekday], from: date)
                let dayOfWeek = (components.weekday ?? 0) - 1
                let selectedDate = dateFormater.string(from: date)
                arrDates.append((weekday: dayOfWeek, date: selectedDate))
            }
        }

        let firstDatindex = arrDates.first?.weekday ?? 0
        
        for n in 1...firstDatindex {
            items.append(CalendarItem(id: n))
        }
        
        for n in firstDatindex...34 {
            if n < arrDates.count + firstDatindex {
                                
                let apiDate = arrDates[n-firstDatindex].date.components(separatedBy: ",").last?.trimmingCharacters(in: .whitespacesAndNewlines).formatToApiDate
                
                items.append(CalendarItem(id: n, date: apiDate))
                
            } else {
                items.append(CalendarItem(id: n))
            }
        }

        return items
    }
    
    func isDate(_ date: Date, between startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
    }
}
