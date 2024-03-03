import SwiftUI

struct CalendarView: View {
    @State private var selectedDates: Set<Date> = []

    var body: some View {
        VStack {
            Text("Selected Dates: \(selectedDates.count > 0 ? "\(selectedDates)" : "None")")

            CalendarGridView(selectedDates: $selectedDates)
        }
    }
}

struct CalendarGridView: View {
    @Binding var selectedDates: Set<Date>

    var body: some View {
        VStack {
            ForEach(0..<5, id: \.self) { weekIndex in
                HStack {
                    ForEach(0..<7, id: \.self) { dayIndex in
                        CalendarCell(day: weekIndex * 7 + dayIndex + 1, selectedDates: $selectedDates)
                            .onTapGesture {
                                withAnimation {
                                    toggleSelection(day: weekIndex * 7 + dayIndex + 1)
                                }
                            }
                    }
                }
            }
        }
    }

    func toggleSelection(day: Int) {
        let date = Calendar.current.date(byAdding: .day, value: day - 1, to: Date()) ?? Date()

        if selectedDates.contains(date) {
            selectedDates.remove(date)
        } else {
            selectedDates.insert(date)
        }
    }
}

struct CalendarCell: View {
    let day: Int
    @Binding var selectedDates: Set<Date>

    var body: some View {
        let date = Calendar.current.date(byAdding: .day, value: day - 1, to: Date()) ?? Date()

        Text("\(day)")
            .padding(10)
            .background(selectedDates.contains(date) ? Color.blue : Color.white)
            .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
