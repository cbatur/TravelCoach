
import SwiftUI

struct CalendarMonthView: View {
    
    var dates: (Date?, Date?) -> Void
    var items: [CalendarItem] = []
    var date = Date()
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    func passDates(startDate: Date?, endDate: Date?) {
        dates(startDate, endDate)
    }
    
    var body: some View {
        VStack {
            Text("\(self.date.monthName()), \(self.date.yearName())".uppercased())
                .foregroundColor(.gray)
                .font(.headline).bold()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .leading)

            LazyVGrid(columns: columns) {
                ForEach(self.items, id: \.self) { item in
                    CBCalendarEventCell(dates: passDates, calendarItem: item)
                }
            }
        }
        .padding(5)
    }
}

struct CBCalendarEventCell: View {
        
    var dates: (Date?, Date?) -> Void

    var calendarItem: CalendarItem?
    @State private var startDate: Date?
    @State private var endDate: Date?

    func processCellClicks(_ dateString: String?) {
        guard let dateString = dateString else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let clickedDate = dateFormatter.date(from: dateString) else { return }
        
        let currentDate = Date()

        if let selectedStartDate = startDate {
            // If startDate is already selected, check if clickedDate is in the future
            if clickedDate > selectedStartDate && clickedDate > currentDate {
                endDate = clickedDate
            } else {
                // If clickedDate is not in the future, do not change anything
                return
            }
        } else {
            // No startDate selected, set it if clickedDate is in the future
            if clickedDate > currentDate {
                startDate = clickedDate
                endDate = nil
            }
        }
        
        dates(startDate, endDate)
    }
    
    func cellColor(dateString: String?) -> Color {
        
        guard let dateString = dateString else { return Color.clear }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let selectedDate = dateFormatter.date(from: dateString) else {
            return .accentColor.opacity(0.3)
        }

        if let startDate = startDate, let endDate = endDate {
            if selectedDate >= startDate && selectedDate <= endDate {
                return .red.opacity(0.3)
            }
        }

        return .accentColor.opacity(0.3)
    }
    
    func resetDates() {
        startDate = nil
        endDate = nil
    }
    
    var body: some View {
        VStack() {
            if (self.calendarItem?.date != nil) {
                Button {
                    guard let dateString = self.calendarItem?.date else { return }
                    self.processCellClicks(dateString)
                } label: {
                    Text(self.calendarItem?.date != nil ? self.calendarItem?.date?.components(separatedBy: "-")[2] ?? "" : "0")
                        .foregroundColor(.white)
                        .font(.subheadline).bold()
                }
            } else {
                Text("\(self.calendarItem?.id.getDayName ?? "")")
                    .foregroundColor(.gray)
                    .padding(.leading, 11)
                    .font(.caption)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, alignment: .leading)
            }
        }
        .frame(width: 44, height: 44)
        .padding(2)
        .background(cellColor(dateString: self.calendarItem?.date))
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 4))
        .shadow(color: self.calendarItem?.date != nil ? .gray : Color.gray, radius: 0, x: 0, y: 0)
    }
}
